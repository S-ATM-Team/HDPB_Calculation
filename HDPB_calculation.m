function [U,L,global_para]=HDPB_calculation(Rbearing,Length,relative_gap_ratio,bearing_num,bearing_single_Length,Fx,Fy,Fz,RS,beairng_pitch,Vis,Den,calculation_mode,epsilion,titling1,titling2,temp_cal_type)
%% 结构参数
global_para.structure_para.Rbearing=Rbearing;
global_para.structure_para.Length=Length;
global_para.structure_para.CR=relative_gap_ratio;
%% 结构分割参数
global_para.bearing_split.bearing_num=bearing_num;
global_para.bearing_split.bearing_single_Length=bearing_single_Length;
%% 工况参数
global_para.work_condition.Fx=Fx;
global_para.work_condition.Fy=Fy;
global_para.work_condition.Fz=Fz;
global_para.work_condition.RS=RS;
global_para.work_condition.Vis=Vis;
global_para.work_condition.DEN0=Den;
global_para.work_condition.bearing_pitch_radius=beairng_pitch;
%% 初始计算参数
global_para.initial_para.epsilon=epsilion;
global_para.initial_para.titling1=titling1;
global_para.initial_para.titling2=titling2;
%% 计算模式
global_para.switch.calculation_mode=calculation_mode;
global_para.switch.DENVIS_switch=temp_cal_type;
%% 迭代计算
global_para=interation_solver(global_para);
end