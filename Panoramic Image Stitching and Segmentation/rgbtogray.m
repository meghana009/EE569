function y = rgbtogray(x)
    
    mat_r = x(:,:,1);
    mat_g = x(:,:,2);
    mat_b = x(:,:,3);

    [height, width] = size(mat_r);

    for j = 1 : height
        for i = 1: width
            y(j,i) = 0.2989*mat_r(j,i) + 0.5870*mat_g(j,i) + 0.1140*mat_b(j,i);
        end
    end
end
