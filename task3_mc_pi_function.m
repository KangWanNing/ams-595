function [pi_hat, n_used, delta, tol_s] = task3_mc_pi_function(sigfigs, alpha, Nmax, seed, plotEvery)
% TASK3_MC_PI_FUNCTION


%  Parameters and defaults
if nargin < 1 || isempty(sigfigs), error('sigfigs must be a positive integer.'); 
end
if nargin < 2 || isempty(alpha),   alpha   = 0.05; 
end
if nargin < 3 || isempty(Nmax),    Nmax    = 1e7; 
end
if nargin < 4,                     seed    = 1;    
end
if nargin < 5 || isempty(plotEvery), plotEvery = 5000; 
end
if sigfigs < 1 || sigfigs ~= floor(sigfigs)
    error('sigfigs must be an integer >= 1.');
end
if ~isempty(seed), rng(seed); end

% Plot toggle: plotting is disabled if plotEvery <= 0 or [] 
doPlot = ~(isempty(plotEvery) || plotEvery <= 0);

% Normal quantile z_{1-α/2}
if exist('norminv','file')
    z = norminv(1 - alpha/2);
else
    z = sqrt(2) * erfcinv(alpha);   % fallback if Statistics Toolbox is unavailable
end

% Figure initialization (only if plotting) 
if doPlot
    fig = figure('Name','Monte Carlo \pi (Task 3)','NumberTitle','off');
    clf; hold on; axis equal; box on;
    xlim([0 1]); ylim([0 1]); xlabel('x'); ylabel('y');
    title(sprintf('Animating random points... target: %d significant figures', sigfigs));

    % Unit square border and quarter circle
    plot([0 1 1 0 0],[0 0 1 1 0],'k-');
    t  = linspace(0, pi/2, 300);
    hq = plot(cos(t), sin(t), 'k-', 'LineWidth', 1.2);

    % Pre-create scatter handles (red: inside; blue: outside) for efficient updates
    hin  = scatter(nan, nan, 10, 'filled', ...
                   'MarkerFaceColor', [0.85 0.25 0.25], 'MarkerFaceAlpha', 0.6);
    hout = scatter(nan, nan, 10, 'filled', ...
                   'MarkerFaceColor', [0.20 0.35 0.90], 'MarkerFaceAlpha', 0.6);
    legend([hq, hin, hout], {'quarter circle','inside','outside'}, ...
           'Location','southoutside','Orientation','horizontal');

    % Text panel (shows current n, pi_hat, CI half-width, etc.)
    txt = text(0.01, 0.99, '', 'Units','normalized', ...
               'HorizontalAlignment','left', 'VerticalAlignment','top', ...
               'FontName','Consolas', 'FontSize',10);
end

%  Statistics initialization 
inside = 0;            % number of hits inside the circle
n      = 0;            % number of samples drawn
pi_hat = NaN;
delta  = Inf;
tol_s  = Inf;

%  Batch size & plotting buffers 
if doPlot
    batch = max(1, round(plotEvery));   % when plotting, refresh every plotEvery points
    xin = []; yin = []; xout = []; yout = [];
else
    batch = 1e5;                        % when not plotting, use a large batch for speed
end

% Main loop: while until criterion is met 
stopFlag = false;
while n < Nmax && ~stopFlag
    % Generate a batch of random points
    B = min(batch, Nmax - n);           % last batch may be smaller
    x = rand(B,1);  y = rand(B,1);
    isIn = (x.^2 + y.^2) <= 1;

    % Sequential (point-by-point) sampling for statistical semantics
    for j = 1:B
        n = n + 1;
        if isIn(j)
            inside = inside + 1;
            if doPlot, xin(end+1,1)  = x(j); yin(end+1,1)  = y(j); end
        else
            if doPlot, xout(end+1,1) = x(j); yout(end+1,1) = y(j); end
        end

        % Estimate and CI half-width
        p_hat  = inside / n;
        se_p   = sqrt(max(p_hat*(1 - p_hat), eps) / n);
        pi_hat = 4 * p_hat;
        delta  = 4 * z * se_p;

        % Absolute rounding threshold (half-ULP) for s significant figures
        if pi_hat > 0
            k     = floor(log10(abs(pi_hat)));
            tol_s = 0.5 * 10^(k - sigfigs + 1);
        else
            tol_s = inf; % ignore early unstable numbers
        end

        % Stop only when 0 < p_hat < 1 (se>0) AND CI half-width is within tol_s
        if inside > 0 && inside < n && (delta <= tol_s)
            stopFlag = true;
            break;
        end
    end

    %  Refresh plot (only if plotting) 
    if doPlot
        % Guard against deleted handles (e.g., user closed the figure)
        if ~(isgraphics(hin,'scatter') && isgraphics(hout,'scatter'))
            % If the window was closed, stop plotting
            doPlot = false;
        else
            set(hin,  'XData', xin,  'YData', yin);
            set(hout, 'XData', xout, 'YData', yout);
            pi_str = sprintf(['%.' num2str(sigfigs) 'g'], pi_hat);
            set(txt, 'String', sprintf(['n = %d\n' ...
                                        '\\pi^ = %s  (%.8f)\n' ...
                                        'CI half-width = %.3e  (tol_s = %.3e)\n' ...
                                        '(1-\\alpha) = %.0f%%'], ...
                                        n, pi_str, pi_hat, delta, tol_s, (1-alpha)*100));
            drawnow limitrate;
        end
    end
end

% Output & (optional) on-figure annotation
n_used = n;
pi_str = sprintf(['%.' num2str(sigfigs) 'g'], pi_hat);

fprintf('Final result:\n');
fprintf('  s = %d, n_used = %d\n', sigfigs, n_used);
fprintf('  pi_hat = %s  (raw = %.8f)\n', pi_str, pi_hat);
fprintf('  CI half-width = %.3e,  tol_s = %.3e  (alpha = %.3f)\n', ...
        delta, tol_s, alpha);

% If plotting, annotate the final rounded value of pi on the figure
if doPlot && isgraphics(gcf,'figure')
    text(0.01, 0.05, sprintf('\\bf\\pi \\approx %s', pi_str), ...
         'Units','normalized','FontSize',12, 'Color',[0.1 0.1 0.1], ...
         'HorizontalAlignment','left','VerticalAlignment','bottom');
end

% Warn if the criterion was not met before hitting Nmax
if ~(inside > 0 && inside < n && (delta <= tol_s))
    warning('Reached Nmax=%d without meeting the criterion for s = %d.', Nmax, sigfigs);
end
end

