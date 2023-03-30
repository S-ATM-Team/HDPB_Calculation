function [T_B,h_min,So,beta,T_ex1,Q,psi_eff,psi_bar,epsilon,f,U,L,global_para]=iteration_new_equation(T_en,D,N_B,N_J,B,CR,F,T_amb,d_l,p_en,cal_type,HolePosition,U,L,global_para)
% [T_B,h_min,So,beta,T_ex1,Q,psi_eff,psi_bar,epsilon,f,U,L,global_para]=iteration_new_equation(T_en,delta_min,delta_max,D,alpha_IB,alpha_IJ,N_B,N_J,B,F,T_amb,k_A,A,d_l,p_en,cal_type,HolePosition,U,L,global_para)
%% 周向油槽补丁
num_oil_groove=1;
if HolePosition==3
    bG=(global_para.structure_para.Length-global_para.split_para.bearing_single_Length*global_para.split_para.bearing_num)/(global_para.split_para.bearing_num-1)*1E-3;
    num_oil_groove=global_para.split_para.bearing_num-1;
    if global_para.split_para.bearing_num~=1
        F=F/global_para.split_para.bearing_num;
        B=global_para.split_para.bearing_single_Length*1E-3;
    end
end
%% lubricant(将该部分移到了前边)
% global_para.result.count = global_para.result.count +1;
% if global_para.result.i>0
%     global_para.result.T_ex0 = 0.5*global_para.result.T_ex1+0.5*global_para.result.T_ex0;
% end
% global_para.result.i=1;
% global_para.result.T_B = 0.5*(global_para.result.T_ex0+global_para.temp_calculation.inlet_temp);
%%
T_B=global_para.result.T_B;

if global_para.work_condition.bearing_oil_type==1
    eta_eff = vis(T_B);
elseif global_para.work_condition.bearing_oil_type==2
    eta_eff = global_para.work_condition.Vis*exp(log(global_para.work_condition.Vis+9.67)*(((T_B+273.15-138)/(global_para.temp_calculation.T_envir+273.15-138))^(-1.1)-1));
elseif global_para.work_condition.bearing_oil_type==3
    eta_eff = vis_100(T_B);
end

% psi_bar = (delta_min/D+delta_max/D);
psi_bar=0;
% psi_delta = (alpha_IB-alpha_IJ)*(global_para.result.T_B-20);
psi_eff = CR;

omega_B = 2*pi*N_B;
omega_J = 2*pi*N_J;
omega_h = omega_B+omega_J;
%% 求解 滑动轴承的端泄量、摩擦力和摩擦系数
[U,L,global_para]=bearing_property(U,L,global_para);
Q3=global_para.result.Leakage/60/1000;
f_force=global_para.result.fri_force;
f=global_para.result.fri_coef;
%% 最小油膜厚度
h_min = global_para.structure_para.Rbearing*global_para.structure_para.CR*(1-global_para.initial_para.epsilon);
%% 润滑油油膜压力产生的热流量
P_thf = f*global_para.work_condition.Wkn*1000*global_para.structure_para.Rbearing*1E-3*omega_h;

%% 供油量/供油压力
if global_para.temp_calculation.heat_type==1
    %% 供油压力
    q_L = 1.204+0.368*(d_l/B)-1.046*(d_l/B)^2+1.942*(d_l/B)^3;
    if HolePosition==1
        %% 轴承载荷反向位置单油孔供油，轴承包角为360°
        Q_Px = pi/48/log(B/d_l)/q_L*(1+global_para.initial_para.epsilon)^3;
    elseif HolePosition==3
        %% 周向全油槽供油，轴承包角为360°
        Q_Px = pi/24*(1+1.5*global_para.initial_para.epsilon^2)/(global_para.structure_para.Length*1E-3/d_l)*global_para.structure_para.Length*1E-3/(global_para.structure_para.Length*1E-3-bG);
    elseif HolePosition==2
        errordlg('双侧进油记得删除');
    end
    Q_P=Q_Px*(D^3*psi_eff^3*p_en/eta_eff)*num_oil_groove;
elseif global_para.temp_calculation.heat_type==2
    %% 供油量
    Q_P=global_para.temp_calculation.inlet_flow/60/1000;
end
%% 润滑油总流量
Q = Q3+Q_P;
%%
global_para.result.T_ex1 = global_para.temp_calculation.inlet_temp + P_thf/1.8e6/Q;
T_ex1=global_para.result.T_ex1;
%%
So=0;
beta=0;
epsilon=global_para.initial_para.epsilon;
%%
if global_para.result.count ==14
    global_para.result.temp = global_para.result.T_B;
end
if global_para.result.count ==15
    global_para.result.T_B = 0.5*global_para.result.temp+0.5*global_para.result.T_B;
end
