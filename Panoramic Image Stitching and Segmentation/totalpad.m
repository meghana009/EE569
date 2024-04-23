function y = totalpad(x,m)
    
    %[height, width] = size(x);
    
    t = (m - 1)/2;
    Atemp = x;
    for j = 1: t
        Atemp = pad(Atemp);
    end

    y = Atemp;
end
    