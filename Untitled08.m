% Part 8: Calculate the boundary length based on the fitted curve (consistent with the main function).
clc; clear; close all
load fit_poly.mat     % read p, a, b (use the a and b saved in part7)

dp = polyder(p);                          % f'(x)
ds = @(x) sqrt(1 + (polyval(dp, x)).^2);  % the formula provided in the question
len = integral(ds, a, b);

fprintf('Length of fitted boundary on [%g, %g] = %.10f\n', a, b, len);


