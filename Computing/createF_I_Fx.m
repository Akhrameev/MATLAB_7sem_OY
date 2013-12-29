function [  ] = createF_I_Fx( s1,s2,s3,n )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    fid = fopen('Computing/ComputingTmp/Fx.m','w');
    clear('Fx.m');
    fprintf(fid,'function [du] = Fx(x)\n');
    fprintf(fid,'\t du = zeros(%u,1);\n',n);
    for i=1:n
        fprintf(fid,'\t du(%u) = %s;\n',i,parser(char(s1(i))));
    end
    fprintf(fid,'end');
    fclose(fid);
    fid = fopen('Computing/ComputingTmp/I.m','w');
    clear('I.m');
    fprintf(fid,'function [j] = I(x,t,u)\n');
    fprintf(fid,'\t j = %s;\n',parser(char(s2)));
    fprintf(fid,'end');
    fclose(fid);
    fid = fopen('Computing/ComputingTmp/F.m','w');
    clear('F.m');
    fprintf(fid,'function [j] = F(x)\n');
    fprintf(fid,'\t j = %s;\n',parser(char(s3)));
    fprintf(fid,'end');
    fclose(fid);
end

