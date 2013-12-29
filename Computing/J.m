function [ j,X ] = J( uk,x0 )
% Summary of this function goes here
%   Detailed explanation goes here
global connectedMethod u T numberOfSteps;
u = uk;
[T,X] = connectedMethod(@sol_x,T,x0);
L = zeros(numberOfSteps,1);
for i=1:numberOfSteps
    L(i) = I(X(i,:),T(i),uk(i,:));
end
j = trapz(T,L);
j = j+F(X(end,:));
end

