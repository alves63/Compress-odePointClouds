function [x1,x2] = rec(y,y1,y2)

x1 = and(y,not(y1));
x2 = and(y,not(y2));