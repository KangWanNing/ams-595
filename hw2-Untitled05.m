% Part 5: Test fractal(c) & visualize Mandelbrot set with matrix + imshow
clc; clear; close all
% test the single points
c_list = [-1 + 0i, 0.25 + 0i, -0.75 + 0.1i, -1.2 + 0.2i];
for k = 1:numel(c_list)
    it = fractal(c_list(k));
    fprintf('c = % .3f %+ .3fi  ->  iter = %d\n', real(c_list(k)), imag(c_list(k)), it);
end
% generate the entire complex plane grid
nx = 500; ny = 400;                  % set resolution manually
x = linspace(-2, 1, nx);             % Real part range
y = linspace(-1.5, 1.5, ny);         % Imaginary number range

IT = zeros(ny, nx);                  % Store the iteration count for each point

% double loop: for each (x, y), compute fractal(c)
for ix = 1:nx
    for iy = 1:ny
        c = x(ix) + 1i * y(iy);
        IT(iy, ix) = fractal(c);     % Store in matrix
    end
end

% visualize(imshow)
figure;
imshow(IT, [0, 100], 'XData', x, 'YData', y);   % 0~100 corresponding iteration limit
axis on; axis xy;                               % maintain coordinate direction consistency
colormap(hot); colorbar;
xlabel('Real(c)'); ylabel('Imag(c)');
title('Part 5: Mandelbrot Set Visualization via imshow')
