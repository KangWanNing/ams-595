function m = bisection(fn_f, s, e)
% find the sign change points (boundaries) of fn_f within [s,e].
    fs = fn_f(s);
    fe = fn_f(e);
    if fs == 0, m = s; return; end % If an endpoint happens to be a “sign change point” (where the function value is zero), return that endpoint directly as the result.
    if fe == 0, m = e; return; end
    if fs * fe > 0 % If the endpoints have the same sign, it indicates that the sign change point does not lie within this interval.
        error('bisection: interval does not bracket a sign change.');
    end

    tol = 1e-6; % When the interval length is less than tol, it is considered sufficiently close to the boundary point. However, as long as the interval remains “sufficiently wide,” the interval continues to be divided by binary search.
    while (e - s) > tol
        m  = (s + e)/2;
        fm = fn_f(m);
        if fs * fm < 0   % In the bisection, one endpoint must have the opposite sign to guarantee the existence of a sign change point within the interval.
            e = m; fe = fm;
        else
            s = m; fs = fm;
        end
    end
    m = (s + e)/2;
end
