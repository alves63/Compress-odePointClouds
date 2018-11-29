function [y,y1,y2] = dec(x1,x2)

y = or(x1,x2);
y1 = xor(y,x1);
y2 = xor(y,x2);