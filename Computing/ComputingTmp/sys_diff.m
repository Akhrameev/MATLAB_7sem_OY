function [dx] = sys_diff(t,x,u)
	 dx = zeros(1,1);
	 dx(1) = u(1);
end