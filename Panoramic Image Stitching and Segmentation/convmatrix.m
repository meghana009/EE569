function y = convmatrix(x,f)
    
    [height, width, depth] = size(x);
    [h1,w1,d1] = size(f);
    h2 = height - h1 + 1;
    w2 = width - w1 + 1;
    y = zeros(h2,w2,d1);
    
    for k = 1:depth
        for j = 1:h2
            for i = 1:w2
                
                y(j,i,k) = sum(sum(x(j:j+4,i:i+4,k).*f(:,:,k)));
            
            end
        end
    end
end
