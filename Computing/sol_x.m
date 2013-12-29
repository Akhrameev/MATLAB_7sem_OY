function [ dx ] = sol_x( t,x )
%SOL_X Summary of this function goes here
%   Detailed explanation goes here
global u T;
c = interp1(T,u,t);
dx = sys_diff(t,x,c);
end

