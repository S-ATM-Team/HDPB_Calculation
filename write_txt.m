function write_txt(unit_p,unit_h,global_para)
%%
Length=global_para.split_para.single_Length;
unit_p=unit_p/1E6;
[m,n]=size(unit_p);
%% д�� ��Ĥ���  ��λ��mm
fid_1=fopen('HXY.txt','w');
for I=1:m
    for J=1:n
        if J==n
            fprintf(fid,'%e\n',unit_h(I,J));
        else
            fprintf(fid,'%e\t',unit_h(I,J));
        end
    end
end
fclose(fid_1);
%% д�� ��Ĥѹ��  ��λ��Mpa
fid_2=fopen('PXY.txt','w');
for I=1:m
    for J=1:n
        if J==n
            fprintf(fid,'%e\n',unit_p(I,J));
        else
            fprintf(fid,'%e\t',unit_p(I,J));
        end
    end
end
fclose(fid_2);
%% д�� X
X=linspace(0,2*pi,m);
X=X';
save('Xaxis.txt','X','-ascii');
%% д�� Y
Y=linspace(0,2*pi,Length);
Y=Y';
save('Yaxis.txt','Y','-ascii');
end