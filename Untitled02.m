% task2_mc_pi_while_sigfig.m
% Task 2: keep sampling with a while loop
% until the estimate is guaranteed to have s significant figures.
% the stopping rule does NOT use the true value of pi.

clear; clc;

% Parameters 
alpha   = 0.05;             % 1 - confidence level (95%)
s_list  = [2 3 4];          % list of target significant-figure counts
Nmax    = 1e7;              % safety cap on total iterations
seed    = 1;                % RNG seed

rng(seed);

% z_{1-α/2}
if exist('norminv','file')
    z = norminv(1 - alpha/2);
else
    z = sqrt(2) * erfcinv(alpha);   % fallback when Statistics Toolbox is unavailable
end

fprintf('Task 2: while loop — guarantee s significant figures (alpha = %.3f)\n', alpha);
fprintf(' s\t  n_used(iterations)\t   pi_hat\t     delta\t     tol_s\n');
fprintf('---------------------------------------------------------------\n');

% Traverse s_list using a while loop (instead of "for s = s_list") 
i = 1;
while i <= numel(s_list)
    s = s_list(i);

    % start an independent run
    inside = 0; n = 0;
    pi_hat = NaN; delta = Inf; tol_s = Inf;

    % pointwise sampling (inner while loop) 
    while n < Nmax
        n = n + 1;
        x = rand; y = rand;
        if x*x + y*y <= 1
            inside = inside + 1;
        end

        % estimate and CI half-width
        p_hat = inside / n;
        se_p  = sqrt(max(p_hat*(1 - p_hat), eps) / n);
        pi_hat = 4 * p_hat;
        delta  = 4 * z * se_p;

        % absolute rounding threshold corresponding to s significant figures
        if pi_hat > 0
            k = floor(log10(abs(pi_hat))); % base-10 order (magnitude) of |pi_hat|
            tol_s = 0.5 * 10^(k - s + 1);  % half-ULP at the s-th significant digit
        else
            tol_s = inf;
        end

        % stop only when se>0 (i.e., 0 < p_hat < 1) and the CI is within tol_s
       
        if inside>0 && inside<n && (delta <= tol_s) % "inside>0"  → at least one hit inside the quarter circle (avoid p_hat=0)；
                                                    % "inside<n"  → not all points inside (avoid p_hat=1)
            break;
        end
    end

    if n == Nmax && ~(delta <= tol_s)
        warning('Reached Nmax without meeting the criterion for s = %d.', s);
    end

    fprintf(' %d\t %8d\t %.8f\t %.3e\t %.3e\n', s, n, pi_hat, delta, tol_s);

    % advance outer while-loop index
    i = i + 1;
end


