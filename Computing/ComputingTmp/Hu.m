function [du] = Hu(x,t,u,p)
	 du = zeros(1,1);
	 du(1) = p(1);
end