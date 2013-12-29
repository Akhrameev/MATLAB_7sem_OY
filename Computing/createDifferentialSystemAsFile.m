function [  ] = createDifferentialSystemAsFile( s1,s2,s3,n,r )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    global differentialSystem;
    fid = fopen('Computing/ComputingTmp/sys_diff.m','w');
    clear('sys_diff.m');
    fprintf(fid,'function [dx] = sys_diff(t,x,u)\n');
    fprintf(fid,'\t dx = zeros(%u,1);\n',n);
    for i=1:n
        fprintf(fid,'\t dx(%u) = %s;\n',i,parser(differentialSystem{i,1}));
    end
    fprintf(fid,'end');
    fclose(fid);
    fid = fopen('Computing/ComputingTmp/sys_psi.m','w');
    clear('sys_psi.m');
    fprintf(fid,'function [dp] = sys_psi(t,p,x,u)\n');
    fprintf(fid,'\t dp = zeros(%u,1);\n',n);
    for i=1:n
        fprintf(fid,'\t dp(%u) = %s;\n',i,parser(char(s1(i))));
    end
    fprintf(fid,'end');
    fclose(fid);
    fid = fopen('Computing/ComputingTmp/Hu.m','w');
    clear('Hu.m');
    fprintf(fid,'function [du] = Hu(x,t,u,p)\n');
    fprintf(fid,'\t du = zeros(%u,1);\n',r);
    for i=1:r
        fprintf(fid,'\t du(%u) = %s;\n',i,parser(char(s2(i))));
    end
    fprintf(fid,'end');
    fclose(fid);
    fid = fopen('Computing/ComputingTmp/H.m','w');
    clear('H.m');
    fprintf(fid,'function [du] = H(x,t,u,p)\n');
    fprintf(fid,'\t du = %s;\n',parser(char(s3)));
    fprintf(fid,'end');
    fclose(fid);

end

