% Part 6: boundary points along x ∈ [-2,1] (≥ 10^3 points)
clc; clear; close all

x_grid = linspace(-2, 1, 1000); % The requirements in the question
y_bnd  = nan(size(x_grid)); % corresponding to 'y'

for k = 1:numel(x_grid)
    x0 = x_grid(k);
    fn = indicator_fn_at_x(x0); % Call the function indicator_fn_at_x(x0), which returns the indicator function fn(y) along the vertical line x = x₀:+1,-1

    % Initial interval (lower bound within the set at y=0, upper bound outside the set at y=1.5)
    s = 0.0; e = 1.5; grow = 0;
    while fn(s) == fn(e) && grow < 12     % If upper and lower bounds share the same sign (boundaries are not “enclosed”), automatically expand the interval symmetrically.
        s = s - 0.25; e = e + 0.25; grow = grow + 1; % Each time: decrease by 0.25; increase by 0.25,until the signs at both ends become opposite (indicating the boundary has been crossed) or after 12 iterations.
    end
    if fn(s) ~= fn(e)
        y_bnd(k) = bisection(fn, s, e);
    end
end

% Clean valid boundary points (remove NaN)
mask = ~isnan(y_bnd);
x_valid = x_grid(mask);
y_valid = y_bnd(mask);

% Save for later steps
save('boundary_points.mat', 'x_grid', 'y_bnd');

% visualization
figure;
plot(x_grid, y_bnd, 'k.', 'MarkerSize', 5)
xlabel x; ylabel y; grid on;
title('Part 6: boundary points (NaN removed later)');

% Print selected boundary points on the command line 
fprintf('\n=== Boundary Points Found (x, y) ===\n');

n_show = 10;   % Display 10 points each at the front and rear
n_total = numel(x_valid);

if n_total <= 2 * n_show
    
    for i = 1:n_total
        fprintf('x = %8.5f ,  y = %8.5f\n', x_valid(i), y_valid(i));
    end
else
    % the first 10 points 
    for i = 1:n_show
        fprintf('x = %8.5f ,  y = %8.5f\n', x_valid(i), y_valid(i));
    end
    fprintf('   ... (%d points omitted) ...\n', n_total - 2 * n_show);
    % the last 10 points
    for i = n_total - n_show + 1 : n_total
        fprintf('x = %8.5f ,  y = %8.5f\n', x_valid(i), y_valid(i));
    end
end

fprintf('\nTotal valid boundary points found: %d / %d\n', n_total, numel(x_grid));
