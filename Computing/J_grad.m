function [ g ] = J_grad( x0,optx,optp,uk )
%J_GRAD Summary of this function goes here
%   Detailed explanation goes here
global x u T;
global directMethod connectedMethod;
global managementDimension numberOfSteps;
u = uk;
[T,x]=connectedMethod(@sol_x,T,x0,optx);
T = T(end:-1:1);
x = x(end:-1:1,:);
[T,p]=directMethod(@sol_psi,T,Fx(x(:,1)),optp);  
T = T(end:-1:1); 
x = x(end:-1:1,:);
p = p(end:-1:1,:);
g = zeros(numberOfSteps,managementDimension);
for i=1:numberOfSteps
    g(i,:) = -1*Hu(x(i,:),T(i),u(i,:),p(i,:));
end
end

