function [du] = H(x,t,u,p)
	 du = -u(1)^2+p(1)*u(1)-x(1)^2;
end