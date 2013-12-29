function [dp] = sys_psi(t,p,x,u)
	 dp = zeros(1,1);
	 dp(1) = 2*x(1)-2*sin(t);
end