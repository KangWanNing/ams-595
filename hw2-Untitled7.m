% Part 7:Fit a 15th-order polynomial to the selected boundary points.
clc; clear; close all
load boundary_points.mat    % obtain x_grid, y_bnd

% clear NaN
x = x_grid(:); y = y_bnd(:);
mask = ~isnan(x) & ~isnan(y);
x = x(mask); y = y(mask);

% Select the fitting candidate region (first plot(x,y) to view, then adjust these two values)
xmin_fit = -2.0;
xmax_fit =  0.5;
sel = (x >= xmin_fit) & (x <= xmax_fit);
x_fit = x(sel);
y_fit = y(sel);

% Consistent with the main function: The interval actually used for integration is denoted as the “valid data range.”
a = min(x_fit);
b = max(x_fit);   

% fit 15-th order
n = 15;
p = polyfit(x_fit, y_fit, n);

% visual inspection (same as main function)
figure; 
plot(x, y, '.', 'DisplayName','boundary raw'); hold on;
xx = linspace(min(x_fit), max(x_fit), 2000);
yy = polyval(p, xx);
plot(x_fit, y_fit, 'k.', 'DisplayName','fit data used');
plot(xx, yy, 'r-', 'LineWidth', 1.2, 'DisplayName','order-15 polyfit');
legend; grid on; xlabel x; ylabel y; title('Part 7: boundary & polynomial fit');

% Save for Part 8 use — key point: save p and a,b (not xmin_fit/xmax_fit)
save('fit_poly.mat', 'p', 'a', 'b', 'x_fit', 'y_fit', 'n');
fprintf('Part 7 done. Effective interval used for integration: [%g, %g]\n', a, b);

% print the result for polynomial
fprintf('\n=== Polynomial fit summary ===\n');
fprintf('Degree (n)         : %d\n', n);
fprintf('Num points (fit)   : %d\n', numel(x_fit));

% print coefficients item by item（from x^n to x^0）
fprintf('\nCoefficients (descending powers):\n');
for k = 1:numel(p)
    pow = n - (k-1);
    fprintf('  a_%02d (x^%2d) = %+ .10e\n', pow, pow, p(k));
end

% print readable polynomial strings
poly_str = local_poly_str(p, 'x');
fprintf('\nPolynomial:\n  y(x) = %s\n', poly_str);



% convert the coefficient to a human-readable string 
function s = local_poly_str(p, varname)
    % p: 1x(N+1) coefficient vector, descending powers
    % varname: e.g., 'x'
    n = numel(p) - 1;
    parts = strings(size(p));
    for k = 1:numel(p)
        a = p(k);
        pow = n - (k-1);
        if abs(a) < 1e-14, parts(k) = ""; continue; end
        if pow == 0
            term = sprintf('%.8g', a);
        elseif pow == 1
            if abs(a-1) < 1e-14
                term = sprintf('%s', varname);
            elseif abs(a+1) < 1e-14
                term = sprintf('- %s', varname);
            else
                term = sprintf('%.8g*%s', a, varname);
            end
        else
            if abs(a-1) < 1e-14
                term = sprintf('%s^%d', varname, pow);
            elseif abs(a+1) < 1e-14
                term = sprintf('- %s^%d', varname, pow);
            else
                term = sprintf('%.8g*%s^%d', a, varname, pow);
            end
        end
        % uniformly convert the positive sign to the format “+ ...”.
        term = strtrim(term);
        if term(1) ~= '-'
            term = ['+ ' term];
        end
        parts(k) = term;
    end
    s = strjoin(parts(parts ~= ""), ' ');
    if startsWith(s, '+ ')
        s = extractAfter(s, 2);
    end
end


