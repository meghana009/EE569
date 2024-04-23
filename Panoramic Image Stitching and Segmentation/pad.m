function y = pad(x)

    [height, width] = size(x);
    padcol1 = x(:,2);
    padcol2 = x(:,width - 1);

    Anew = [padcol1,x,padcol2];

    padrow1 = Anew(2,:);
    padrow2 = Anew(height - 1,:);

    y = [padrow1;Anew;padrow2];
end

