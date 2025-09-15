% task3_mc_pi_function(2, 0.05, 1e6, 1, 1);   % Demo: 2 significant figures（Users can adjust parameters 2, 3, and 4）, 95% CI, up to 1e6 samples, seed=1, refresh every point

% n significant figures, 95% confidence, at most 5e7 samples, RNG seed=1, refresh plot every 5000 points:
[pi_hat, n_used, delta, tol_s] = task3_mc_pi_function(2, 0.05, 5e7, 1, 5000);


