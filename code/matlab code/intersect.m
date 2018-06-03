% x = linspace(-3,3);
% y1 = @(x) (3*x.^2)+2.*x-10;
% c2=9;
% y2 = @(x) sin(5*x+c2);


function [xint, y1(x), y2(x)] = intersect(y1_m,y1_b,y2_m, y2_b)
y1 = @(x) y1_m * x + y1_b;
y2 = @(x) y2_m*x + y2_b;

for k1 = 1:2
    x0 = 5*(-1)^k1;
    xint(k1) = fzero(@(x) y1(x)-y2(x), x0);
end

figure(1)
plot(x, y1(x))
hold on
plot(x, y2(x))
plot(xint, y1(xint), 'pb')
grid

end
