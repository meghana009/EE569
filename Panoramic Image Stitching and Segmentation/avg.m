function y = avg(x,m)
    
    [height, width] = size(x);
    n = (m - 1)*0.5 ;
    h = height - 2*n;
    w = width - 2*n;
    
    
    for j = 1 + n: h
        for i = 1 + n: w
            
            window_top = max(j - n, 1);
            window_bottom = min(j + n, height);
            window_left = max(i - n, 1);
            window_right = min(i + n, width);
            sumval = x(window_top:window_bottom, window_left:window_right);
            temp = totalsum(sumval,m);
            y(j,i) = temp;
        end
    end
end
