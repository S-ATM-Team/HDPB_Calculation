function [U,L,global_para]=interation_solver(global_para)
%% patch
global_para.result.num=1;
%% 完善结构参数
global_para.structure_para.Rshaft=global_para.structure_para.Rbearing/(1+global_para.structure_para.CR);   % 轴颈半径 mm
global_para.structure_para.C0=global_para.structure_para.Rbearing-global_para.structure_para.Rshaft;             % 半径间隙 mm
%% 完善工况参数
global_para.work_condition.Wkn=2*global_para.work_condition.Fz*1E-3;         % Wkn的单位为 KN，Ft的单位为 N
global_para.work_condition.Msc=2*global_para.work_condition.Fx*global_para.work_condition.bearing_pitch_radius*1E-3;     % N·m 力偶矩的计算公式为 平行力中的一个力与平行力之间距离（称力偶臂）的乘积
%% 初始 润滑油的黏度 参数
if global_para.work_condition.bearing_oil_type==1
    if global_para.switch.DENVIS_switch==1
        %% 当按照标准的计算流程进行公式计算时，需要根据 注油温度 提前迭代计算润滑油的黏度
%         global_para.result.T_ex0=global_para.temp_calculation.inlet_temp+20;
%         global_para.result.T_ex1=0;
%         global_para.work_condtion.Vis=vis(0.5*(global_para.result.T_ex0+global_para.temp_calculation.inlet_temp));
        global_para.work_condition.Vis=vis(global_para.temp_calculation.T_envir);
    elseif global_para.switch.DENVIS_switch==2
        %% 按照标准查表进行计算，直接按照 环境温度计算即可（可用可不用）
        global_para.work_condition.Vis=vis(global_para.temp_calculation.T_envir);
    elseif global_para.switch.DENVIS_switch==3
        %% 三维绝热温度场计算
        global_para.work_condition.Vis=vis(global_para.temp_calculation.T_envir);
    end
elseif global_para.work_condition.bearing_oil_type==2
    %% 当选用2时，填写的润滑介质的黏度就是该环境温度下的黏度
    if global_para.switch.DENVIS_switch==1
        %% 当按照标准的计算流程进行公式计算时，需要根据 注油温度 提前迭代计算润滑油的黏度
%         global_para.result.T_ex0=global_para.temp_calculation.inlet_temp+20;
%         global_para.result.T_ex1=0;
%         TT=0.5*(global_para.result.T_ex0+global_para.temp_calculation.inlet_temp);
%         global_para.work_condition.Vis=global_para.work_condition.Vis*exp(log(global_para.work_condition.Vis+9.67)*(((TT+273.15-138)/(global_para.temp_calculation.T_envir+273.15-138))^(-1.1)-1));

    end
elseif global_para.work_condition.bearing_oil_type==3
    if global_para.switch.DENVIS_switch==1
    elseif global_para.switch.DENVIS_switch==2
        %% 按照标准查表进行计算，直接按照 环境温度计算即可（可用可不用）
        global_para.work_condition.Vis=vis_100(global_para.temp_calculation.T_envir);
    elseif global_para.switch.DENVIS_switch==3
        %% 三维绝热温度场计算
        global_para.work_condition.Vis=vis_100(global_para.temp_calculation.T_envir);
    end
end
%% 完善计算模式
if global_para.work_condition.Msc==0
    global_para.switch.M_switch=0;
    %% 如果既没有弯矩，也设置了要迭代偏心率，则需要关闭轴承的倾斜
    if global_para.switch.calculation_mode==1
        global_para.initial_para.titling1=0;
        global_para.initial_para.titling2=0;
    end
else
    global_para.switch.M_switch=1;
end
%% 网格参数 （存在弯矩只能使用一层网格）
maxlev=1;
ncy=10;
nx = 101;
ny = 41;
nz = 11;         % 油膜求解区域径向方向网格个数
%% 后续要做到主界面内（粗糙峰）
gama=1;        % 粗糙度方向 无量纲
Rqb=0.2;       % 轴承表面的粗糙度 um
Rqs=0.2;       % 轴颈表面的粗糙度 um

global_para.switch.Ra_switch=0;
%% 轴承分段
bearing_num=global_para.split_para.bearing_num;
global_para=bearing_split_para(global_para);
%% 修形参数（先采用默认情况，后边再把界面中的修形参数导入）
global_para=bearing_profile_shaping(global_para,ny);
%% 弹性变形初始化
non_unit_deformation_oil_film=[];
for I=1:bearing_num
    non_unit_deformation_oil_film{I}=zeros(nx,ny);
end
global_para.deform.non_unit_deformation_oil_film=non_unit_deformation_oil_film;
%%
Um = (2.0 * pi * global_para.work_condition.RS/ 60) * (global_para.structure_para.Rshaft / 1e3);    % 轴颈和轴瓦的相对速度 m/s
Pdim=(global_para.structure_para.Rshaft/1e3*global_para.structure_para.CR)^2/(6.0*global_para.work_condition.Vis*Um*global_para.structure_para.Rbearing/1e3);


AttiAng = atan(pi / 4 * sqrt(1 - global_para.initial_para.epsilon^2) / global_para.initial_para.epsilon);
%
global_para.middle_para.Um=Um;
global_para.middle_para.Pdim=Pdim;
global_para.middle_para.AttiAng=AttiAng;
%% 物质状态方程参数
global_para=state_equation_para(global_para);
%%
for I=1:bearing_num
    [U,single_L]=initialize(nx,ny,nz,maxlev,gama,Rqb,Rqs,global_para.structure_para.C0/1E3,global_para.switch.DENVIS_switch,global_para.temp_calculation.T_envir,global_para);
    L{I}=single_L;
end
for level=maxlev:-1:1
    [U,L]=init_uf(U,L,global_para,level,global_para.initial_para.epsilon);
end
%% 循环计算
global_temp_error=1;
M_new=1;
M_angle_curve=1;
global_para.result.count=0;
global_para.result.i=0;
if global_para.switch.DENVIS_switch==1
    global_para.result.T_ex0=global_para.temp_calculation.inlet_temp+20;
    global_para.result.T_ex1=0;
end
while global_temp_error>1E-6
    %% 采用绝热计算---要以整个计算流程为迭代流程（只有当DENVIS_switch==1时才会需要这一步）
    if global_para.switch.DENVIS_switch==1
        global_para.result.count = global_para.result.count +1;
        if global_para.result.i>0
            global_para.result.T_ex0=0.5*global_para.result.T_ex1+0.5*global_para.result.T_ex0;
        end
        global_para.result.i=1;
        global_para.result.T_B=0.5*(global_para.result.T_ex0+global_para.temp_calculation.inlet_temp);
        for floor_num=1:global_para.split_para.bearing_num
            ii=L{floor_num}{1,3};
            jj=L{floor_num}{1,4};
            nz=L{floor_num}{1,5};
            L{floor_num}{1,19}=ones(ii,jj,nz)*(global_para.result.T_B+273.15)/(global_para.temp_calculation.T_envir+273.15);
        end
    end
    %%
    global_temp_error=0;
    for floor_num=1:bearing_num
        old_global_p{floor_num}=L{floor_num}{maxlev,6};    % Note
    end
    %%
    global_para.iteration_para.G_coef_W=1;
    global_para.iteration_para.G_coef_M=1;
    global_para.iteration_para.G_coef_M_angle=1;
    %% 油膜压力计算
    part_p_error=1;
    err_M=1;
    err_M_angle=1;
    while (err_M>1E-3)  || (part_p_error>1E-6) || (err_M_angle>1E-2)
        [U,L,global_para]=fmg(U,L,maxlev,30,2,1,1,ncy,global_para);
        part_p_error=sum(global_para.result.part_p_error);
        if global_para.switch.M_switch==0
            err_M=0;
            err_M_angle=0;
        else
            AttiAng=global_para.middle_para.AttiAng;
            M_new=global_para.result.M_new;
            M_angle_curve=global_para.result.M_angle_curve;
            err_M=abs(M_new-global_para.work_condition.Msc)/M_new;
            err_M_angle=abs(AttiAng-M_angle_curve)/abs(AttiAng);
        end
        %% 迭代油膜厚度分布
        for level=maxlev:-1:1
            U.xa=(2*pi-global_para.work_condition.bearing_angle)/2-global_para.middle_para.AttiAng;
            U.xb=U.xa+global_para.work_condition.bearing_angle;
%             hx=(U.xb-U.xa)/(nx0-1);
%             hy=(U.yb-U.ya)/(ny0-1);
%             for floor_num=1:bearing_num
%                 L{floor_num}{1,1}=hx;
%                 L{floor_num}{1,1}=hy;
%             end
            [U,L]=init_uf(U,L,global_para,level,global_para.initial_para.epsilon);
        end
    end
    %% 将 油膜压力 和 油膜厚度 以及 对应的 X、Y 坐标保存到txt文件中
%     unit_p=L{1}{maxlev,6}/Pdim;      % 单位：Pa
%     unit_h=L{1}{maxlev,7}*C0;
%     write_txt(unit_p,unit_h)
    %% 温度计算(压力已经测试完毕，下边开始测试温度部分)
    if global_para.switch.DENVIS_switch==0
        global_temp_error=0;
    else
        %% 温度值计算
        [U,L,global_para]=temp(U,L,global_para);
        %% 计算温度影响前后的压力误差
        for floor_num=1:bearing_num
            new_global_p{floor_num}=L{floor_num}{1,6};
            global_temp_error=global_temp_error+abs(sum(sum(new_global_p{floor_num}))-sum(sum(old_global_p{floor_num})))/sum(sum(new_global_p{floor_num}));
        end
        %% 如果按照标准计算,可能也需要进行迭代计算
%         if global_para.switch.DENVIS_switch==2
%             global_temp_error=0;
%         end
        fprintf('\n计算温度后的压力误差为：%e',global_temp_error);
    end
end
end