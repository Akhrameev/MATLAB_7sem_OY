function [ y,p ] = sol_zk( x0,optx,optp,uk )
%SOL_ZK Summary of this function goes here
%   Detailed explanation goes here
global x u T;
global directMethod connectedMethod;
u = uk;
[T,x]=connectedMethod(@sol_x,T,x0,optx);
T = T(end:-1:1);
x = flipud(x);
[T,p]=directMethod(@sol_psi,T,Fx(x(:,1)),optp);  
T = T(end:-1:1); 
y = flipud(x);
p = p(end:-1:1,:);
end

