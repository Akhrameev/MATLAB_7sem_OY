function [du] = H(x,t,u,p)
	 du = p(1)*u(1)-(x(1)-sin(t))^2;
end