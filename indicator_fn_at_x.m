function fn = indicator_fn_at_x(x0)
% return to fn(y) ∈ {+1,-1}：The point lies outside the set :+1，The point lies inside the set: -1
    fn = @(y) (fractal(x0 + 1i*y) > 0) * 2 - 1;  % function for determination
end
