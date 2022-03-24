function [v w] = grad_u(x,y)
grad = [cos(pi*x)*sin(pi*y) ;sin(pi*x)*cos(pi*y);