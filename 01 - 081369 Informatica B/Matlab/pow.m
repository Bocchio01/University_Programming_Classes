function [r] = pow (x,y)
    r=1;
    for k=1:y
        r=r*x;
    end
end
