function y = totalsum(x,n)
    
    sumval = 0;
    for j = 1:n
        for i = 1:n
            sumval = sumval + x(j,i)*x(j,i);
        end
    end

    y = sumval/n^2;

end

    
    