%% ��й��������
[X,Y]=size(unit_p);
R=160*1E-3;    % ��λΪ m
L=390*1E-3;    % ��λΪ m
DX=2*pi/(X-1);
DY=L/(Y-1);   % ��λΪ m
single_Q=0;
ppp=unit_p;     % ��λΪ Pa
hhh=unit_h*1E-3;     % ��λΪ m
for I=1:X
    DPDY=(ppp(I,2)-ppp(I,1))/DY;
    single_Q=single_Q+(-R/12)*hhh(I,1)^3/0.2900*DPDY*DX;   % ����0.29Ϊ�¶�Ӱ���֮����ȣ�Ҫ�ǵ��޸�
end
double_Q=single_Q*2;   % ����m/s
double_QQ=double_Q*60; % ����m/min
flow=double_QQ*1000;   % L/min
%% Ħ�����ļ���
fri_force=0;
for I=1:X-1
    for J=1:Y
        DPDX=(ppp(I+1,J)-ppp(I,J))/(R*DX);
        fri_force=fri_force+(0.29*global_para.middle_para.Um/hhh(I,J)+hhh(I,J)/2*DPDX)*DY*(DX*R);     % ����0.29Ϊ�¶�Ӱ���֮����ȣ�Ҫ�ǵ��޸�
    end
end
fri_coef=fri_force/(global_para.work_condition.Wkn*1E3);