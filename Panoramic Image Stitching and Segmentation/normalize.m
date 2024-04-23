function y = normalize(x)
    
    [height, width] = size(x);
    imax = max(x(:));
    imin = min(x(:));

    for j= 1:height
        for i = 1:width
            
            val = (x(j,i) - imin)*((1 - 0)/(imax - imin)) + 0;
            y(j,i) = val;
        end
    end
end
