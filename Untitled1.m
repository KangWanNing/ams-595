% mc_pi_for.m
% Task 1——for loop
% Estimate π by sampling point-by-point with a for loop
% Record the estimation error |pi_hat - pi|
% Record the runtime, and plot precision vs. computational cost

clear; clc;
rng(1);                              % Fix random seed for reproducibility
true_pi = pi;

% Multiple sample sizes (can be increased or decreased as needed)
Ns = round([1e3 2e3 5e3 1e4 2e4 5e4 1e5 2e5]);

PiHat  = zeros(size(Ns));            % Estimated values of π
Err    = zeros(size(Ns));            % Absolute errors
Timing = zeros(size(Ns));            % Runtime (seconds)

fprintf(' N\t\t pi_hat\t\t abs.err\t time(s)\n');

% for loop
for i = 1:numel(Ns)
    N = Ns(i);
    inside = 0;

    t0 = tic;                        % Start timing
     
    for k = 1:N                      % point-by-point sampling
        x = rand(); y = rand();
        if x*x + y*y <= 1.0          % Inside the quarter circle
            inside = inside + 1;
        end
    end
    Timing(i) = toc(t0);             % End timing

    PiHat(i) = 4 * inside / N;       % Estimation of π
    Err(i)   = abs(PiHat(i) - true_pi);

    fprintf('%-8d\t %.6f\t %.3e\t %.3f\n', N, PiHat(i), Err(i), Timing(i));
end

% Plotting
figure('Color','w','Position',[80 80 1100 800]);

% (a) Estimated π vs N
subplot(2,2,1);
semilogx(Ns, PiHat, 'o-','LineWidth',1.2); 
hold on;

yline(true_pi,'--','\pi (true)','LineWidth',1.2);
xlabel('Sample size N (log)'); ylabel('Estimated \pi');
title('Estimated \pi vs N (for loop)'); 
grid on;

% (b) Error vs N with Monte Carlo convergence rate ~ N^{-1/2}
subplot(2,2,2);
loglog(Ns, Err, 'o-','LineWidth',1.2); 
hold on;

C = Err(1) * sqrt(Ns(1));            % Reference line passing through the first point
loglog(Ns, C./sqrt(Ns), '--', 'LineWidth',1.2);
legend('| \pi_{hat} - \pi |', 'C \cdot N^{-1/2}', 'Location','southwest');
xlabel('Sample size N (log)'); ylabel('Absolute error (log)');
title('Error decay and Monte Carlo 1/\surdN rate'); 
grid on;

% (c) Runtime vs N
subplot(2,2,3);
loglog(Ns, Timing, 'o-','LineWidth',1.2);
xlabel('Sample size N (log)'); ylabel('Runtime / s (log)');
title('Runtime vs Sample size'); 
grid on;

% (d) Accuracy–cost tradeoff: Runtime vs Error
subplot(2,2,4);
loglog(Timing, Err, 'o-','LineWidth',1.2);
xlabel('Runtime / s (log)'); ylabel('Absolute error (log)');
title('Accuracy vs Computational cost'); 
grid on;

sgtitle('Monte Carlo Estimation of \pi (for loop, fixed N)','FontWeight','bold');