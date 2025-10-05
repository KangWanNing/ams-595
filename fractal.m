function it = fractal(c)
% 5-1 Determine whether a single point diverges，where fractal(c) is a single point function, not a set
% fractal: iterations until divergence for complex number c.
% returns it in 1..100 if |z|>2 within 100 iters, else 0.

    z = 0; % Initialization
    it = 0; % number of iterations
    maxIter = 100; % Maximum Iteration Limit

    while it < maxIter
        z = z^2 + c;
        it = it + 1;     
        if abs(z) > 2
            return;      % diverge，return to the number of iteration
        end
    end

    it = 0;              % within 100 iterations：inside the set
end
