function [m,b] = slope (x1,x2,y1,y2)

m = (y2-y1)/(x2-x1);
b = y1 - m*x1

end