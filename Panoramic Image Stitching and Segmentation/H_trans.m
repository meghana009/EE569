function [x_new, y_new] = H_trans(H, x, y)
    val = H*[x; y; 1];
    x_new = val(1)/val(3);
    y_new = val(2)/val(3);    
end