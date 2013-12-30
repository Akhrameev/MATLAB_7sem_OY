function [ ns ] = parser( s )
%PARSER Summary of this function goes here
%   Detailed explanation goes here
ns = '';
i = 1;
while i<=length(s)
    ns = strcat(ns,s(i));
    if(s(i)=='x' || s(i)=='u' || s(i)=='p') && s(i+1)>='1' && s(i+1)<='9'
       ns = strcat(ns,'(');       
       while i<length(s) && s(i+1)>='0' && s(i+1)<='9'
           i = i+1;
           ns = strcat(ns,s(i));
       end
       ns = strcat(ns,')');       
    end
    i = i+1;
end

end

