function global_para=state_equation_para(global_para)
%% 释放参数
Vis=global_para.work_condition.Vis;
Pdim=global_para.middle_para.Pdim;
T0=global_para.temp_calculation.T_envir;
%% 参数值
A1 = log(Vis) + 9.67;
A2 = 5.1E-9 / Pdim;
A3 = 1.0 / (1.0 - 138.0 / T0);
A4 = 138.0 / (T0 - 138.0);

CL1 = 0.6E-9 / Pdim;
CL2 = 1.7E-9 / Pdim;
CL3 = 0.00065 * T0;

ALFA = 2.2E-8;
BETA = 0.046;
Z0 = ALFA / (log(Vis) + 9.67) / 5.1E-9;
S0 = BETA * (T0 - 138.0) / (log(Vis) + 9.67);
%% 将物质状态参数储存到 global_para 中
global_para.state_equation.A1=A1;
global_para.state_equation.A2=A2;
global_para.state_equation.A3=A3;
global_para.state_equation.A4=A4;
global_para.state_equation.CL1=CL1;
global_para.state_equation.CL2=CL2;
global_para.state_equation.CL3=CL3;

global_para.state_equation.ALFA=ALFA;
global_para.state_equation.BETA=BETA;
global_para.state_equation.Z0=Z0;
global_para.state_equation.S0=S0;
end