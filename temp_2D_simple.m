function [U,L,global_para]=temp_2D_simple(U,L,global_para)
%% �����ͷźͲ��ֲ������
Dbearing=global_para.structure_para.Rbearing*2;     % ���ֱ��/mm
Length=global_para.structure_para.Length;           % ��п��/mm
CR=global_para.structure_para.CR;                   % ��Լ�϶��

% interface_num=global_para.temp_calculation.interface_num;   % ��ӯ��
% min_gap=Dbearing/2*CR-interface_num;         % ��С��϶/mm
% max_gap=Dbearing/2*CR-interface_num;         % ����϶/mm

% Rz_bearing=global_para.temp_calculation.gear_Ra/1E6;   % ��б���ֲڶ�/m
% Rz_shaft=global_para.temp_calculation.shaft_Ra/1E6;    % �ᾱ����ֲڶ�/m

Wkn=global_para.work_condition.Wkn;          % ����/KN

inlet_temp=global_para.temp_calculation.inlet_temp;   % �������
RS=global_para.work_condition.RS;         % ������е�ת�� rpm

% A=0.3;         % ��е�ɢ�����

hole_diameter=global_para.temp_calculation.hole_diameter;  % �Ϳ�ֱ�� mm

% line_expand_coef_bearing=global_para.temp_calculation.line_expand_coef_bearing;   % ��е�������ϵ��(K^-1)
% line_expand_coef_shaft=global_para.temp_calculation.line_expand_coef_shaft;   % �ᾱ��������ϵ��(K^-1)

hole_type=global_para.temp_calculation.hole_type;       % ����/˫�׽���

% k_A=20;       % �󻬽��ʵ��ȴ���ϵ��
T_envir=global_para.temp_calculation.T_envir;       % �����¶�

pressure_inlet=global_para.temp_calculation.inlet_pressure*1E6;  % �Ϳ׽���ѹ��/Pa

DEN=global_para.work_condition.DEN0;         % �����ܶ�(kg/m^3)

% hole_angle=global_para.temp_calculation.hole_angle;    % ���Ϳ״�ֱ�н�/��
%% limit value
cal_type=2;    % ����ɢ��-1/����ɢ��-2
%% unit change
W=Wkn*1000;
Dbearing=Dbearing/1000;
Length=Length/1000;
% min_gap=min_gap/1000;
% max_gap=max_gap/1000;
hole_diameter=hole_diameter/1000;
RS=RS/60;
%%
[T_B,h_min,So,beta,~,Q,psi_eff,psi_bar,epsilon,f,U,L,global_para]...
    =iteration_new_equation(inlet_temp,Dbearing,...
    RS,0,Length,CR,W,T_envir,hole_diameter,pressure_inlet,cal_type,hole_type,U,L,global_para);
%%
% lambda = h_min/sqrt(Rz_bearing^2+Rz_shaft^2);
if global_para.work_condition.bearing_oil_type==1
    eta = vis(T_B);
elseif global_para.work_condition.bearing_oil_type==2
    eta = global_para.work_condition.Vis*exp(log(global_para.work_condition.Vis+9.67)*(((T_B+273.15-138)/(global_para.temp_calculation.T_envir+273.15-138))^(-1.1)-1));
elseif global_para.work_condition.bearing_oil_type==3
    eta = vis_100(T_B);
end
% C=0.25*min_gap+0.25*max_gap;
%% ���ת��
p_bar=W/Dbearing/Length;
% N_T=p_bar*lambda*sqrt(Rz_bearing^2+Rz_shaft^2)/4.678/C/(Length/Dbearing)^1.044/eta/(Dbearing/2/C)^2;
N_T=0;
%% �������
global_para.result.T=T_B;       % �¶�ֵ
global_para.result.N_T=N_T;     % ���ת��
global_para.result.Vis=eta;     % �󻬽��ʵĹ�����
%% �¶ȴ���
for floor_num=1:global_para.split_para.bearing_num
    ii=L{floor_num}{1,3};
    jj=L{floor_num}{1,4};
    nz=L{floor_num}{1,5};
    L{floor_num}{1,19}=ones(ii,jj,nz)*(T_B+273.15)/(T_envir+273.15);
end
end