function [U,L,global_para]=temp_calculation_3D(U,L,global_para)
%%
global hx hy ii jj kk p h T hx2 hy2
global DEN0 Um Rbearing Vis CR Rshaft CF0 T0 FK0 RoL
global REYN REYNSTAR PRDL EC CLS1 CLS2 OMIGT
%% 参数释放
hx=L{1,1};
hy=L{1,2};
ii=L{1,3};               % 最高层的圆周方向网格个数
jj=L{1,4};               % 最高层的轴向方向网格个数
kk=L{1,5};               % 最高层的油膜厚度方向网格个数

p=L{1,6};                % 最高层的无量纲油膜压力
h=L{1,7};                % 最高层的无量纲油膜厚度

T=L{1,19};               % 无量纲温度分布

hx2=hx*2;
hy2=hy*2;

DEN0=global_para.work_condition.DEN0;
Um=global_para.middle_para.Um;
Rbearing=global_para.structure_para.Rbearing;
Vis=global_para.work_condition.Vis;
CR=global_para.structure_para.CR;
Rshaft=global_para.structure_para.Rshaft;
CF0=global_para.temp_calculation.CFO;
FK0=global_para.temp_calculation.FKO;
T0=U.T0;

RoL=Rbearing/global_para.split_para.bearing_single_Length;
%% 调整 p 和 h的位置，让第 i 行为滑动轴承注油的地方
AttiAng=global_para.middle_para.AttiAng;
DX=2*pi/(ii-1);
adjust_angle=3*pi/2-AttiAng;
ele_num=floor(adjust_angle/DX);
%
% p(end,:)=[];
% former_p=p(ele_num+1:end,:);
% latter_p=p(1:ele_num,:);
% correction_p=[former_p;latter_p];
% correction_p(ii,:)=correction_p(1,:);
% p=correction_p;
%
% h(end,:)=[];
% former_h=h(ele_num+1:end,:);
% latter_h=h(1:ele_num,:);
% correction_h=[former_h;latter_h];
% correction_h(ii,:)=correction_h(1,:);
% h=correction_h;
%% 预先的参数计算
REYN     = DEN0 * Um * (Rbearing / 1e3) / Vis;
REYNSTAR = REYN * (CR * Rshaft / Rbearing)^2;
PRDL     = CF0 * Vis / FK0;
EC       = Um * Um / (CF0 * T0);
CLS1  = REYNSTAR * PRDL;
CLS2  = PRDL * EC;
OMIGT = 0.5;
[U,L,global_para]=TEMPER(U,L,global_para);
%%
% T=L{1,19};
% T(end,:,:)=[];
% former_T=T(ele_num+1:end,:,:);
% latter_T=T(1:ele_num,:,:);
% correction_T=[former_h;latter_h];
% correction_T(ii,:,:)=correction_T(1,:,:);
% L{1,19}=correction_T;
end