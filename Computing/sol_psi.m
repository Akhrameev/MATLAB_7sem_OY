function [ dp ] = sol_psi( t,p )
%SOL_PSI Summary of this function goes here
%   Detailed explanation goes here
global x u T;
tr=interp1(T,x,t);
c = interp1(T,u,t);
dp = sys_psi(t,p,tr,c);
end

