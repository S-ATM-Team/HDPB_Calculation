%% 端泄流量计算
[X,Y]=size(unit_p);
R=160*1E-3;    % 单位为 m
L=390*1E-3;    % 单位为 m
DX=2*pi/(X-1);
DY=L/(Y-1);   % 单位为 m
single_Q=0;
ppp=unit_p;     % 单位为 Pa
hhh=unit_h*1E-3;     % 单位为 m
for I=1:X
    DPDY=(ppp(I,2)-ppp(I,1))/DY;
    single_Q=single_Q+(-R/12)*hhh(I,1)^3/0.2900*DPDY*DX;   % 其中0.29为温度影响过之后的黏度，要记得修改
end
double_Q=single_Q*2;   % 立方m/s
double_QQ=double_Q*60; % 立方m/min
flow=double_QQ*1000;   % L/min
%% 摩擦力的计算
fri_force=0;
for I=1:X-1
    for J=1:Y
        DPDX=(ppp(I+1,J)-ppp(I,J))/(R*DX);
        fri_force=fri_force+(0.29*global_para.middle_para.Um/hhh(I,J)+hhh(I,J)/2*DPDX)*DY*(DX*R);     % 其中0.29为温度影响过之后的黏度，要记得修改
    end
end
fri_coef=fri_force/(global_para.work_condition.Wkn*1E3);