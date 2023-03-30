%% 张博士---多重网格法求解滑动轴承压力场
% 所有的参数都储存在 global_para 中，
% 公共的参数储存在U中，需要分层的参数全部储存到 L 中
clear;
clc;
%% 基本参数
% 结构参数
global_para.structure_para.Rbearing=160;   % 轴承半径 mm
global_para.structure_para.Length=390;     % 轴承长度 mm
global_para.structure_para.CR=0.001;       % 间隙比 无量纲
global_para.structure_para.Rshaft=global_para.structure_para.Rbearing/(1+global_para.structure_para.CR);   % 轴颈半径 mm
global_para.structure_para.C0=global_para.structure_para.Rbearing-global_para.structure_para.Rshaft;             % 半径间隙 mm

gama=1;        % 粗糙度方向 无量纲
Rqb=0.2;       % 轴承表面的粗糙度 um
Rqs=0.2;       % 轴颈表面的粗糙度 um

% 工况参数
Fr=0;       % 径向压缩力 Fy N
Ft=704125;       % 切向力 Fz N
Fax=99000;      % 轴向力 Fx N
pitch_circle_radius=247.12;    % 齿轮节圆半径 mm
global_para.work_condition.Wkn=2*Ft*1E-3;         % Wkn的单位为 KN，Ft的单位为 N
global_para.work_condition.Msc=2*Fax*pitch_circle_radius*1E-3;     % N·m 力偶矩的计算公式为 平行力中的一个力与平行力之间距离（称力偶臂）的乘积
global_para.work_condition.RS=29;         % 轴颈/轴承转速 rpm
global_para.work_condition.Vis=0.2768;            % 润滑油的粘度（Pa*s）
global_para.work_condition.DENO=860;             % 润滑油的密度（kg/m^3）
global_para.work_condition.CFO=2000;             % 润滑油的比热容（J/kg*°C）
global_para.work_condition.FKO=0.13;             % 润滑油的导热系数
%% 网格参数(由于要进行考虑弯矩的计算，所以只能使用一层网格)
maxlev=1;
ncy=10;
nx = 101;
ny = 41;
nz = 11;         % 油膜求解区域径向方向网格个数
%% 初始参数
% 偏心率
global_para.initial_para.epsilon=0.7;

% 轴颈倾斜的两个角度参数:titling1为----，titling2为----
% global titling1 titling2
global_para.initial_para.titling1=0*2*pi/360;       % gama：轴颈在轴承中的倾斜角
global_para.initial_para.titling2=00*2*pi/360;     % alfa：OC2和C1C3之间的夹角

% 温度
global_para.initial_para.T0=273.15+40;
% 将初始参数储存到 global_para 中
% global_para.initial_para.epsilon=epsilon;
% global_para.initial_para.titling1=titling1;
% global_para.initial_para.titling2=titling2;
%% 计算模式
% 是否考虑温度对密度和粘度的影响
% global DENVIS_switch
global_para.switch.DENVIS_switch=0;

% Elastic_deform_switch为是否考虑弹性变形的影响（待开放）
% global Elastic_deform_switch

% 1：固定载荷计算；0：固定偏心率计算
% global calculation_mode
global_para.switch.calculation_mode=1;

% 1：固定弯矩大小；0：固定轴颈位置
% global M_switch M_new M_angle_curve
global_para.switch.M_switch=0;

% 是否考虑粗糙度
% global Ra_switch Kp para_Ra HbR F2p5
global_para.switch.Ra_switch=0;
Ra_switch=global_para.switch.Ra_switch;
if Ra_switch==0
    gama=0;
    Rqb=1E-12;
    Rqs=1E-12;
elseif Ra_switch==1
    %% 当 Ra_switch==1时，固体粗糙峰计算参数from THE CONTACT OF TWO NOMINALLY FLAT ROUGH SURFACES
    Kp=1000*0.098;   % 将单位 kgf/cm^2 转化为单位为 MPa
    para_Ra=0.05;
    HbR=[0,0.5,1,1.5,2,2.5,3,3.5,4];
    F2p5=[0.61664,0.24040,0.08056,0.02286,0.00542,0.00106,0.00017,0.00002,0];
elseif Ra_switch==2
    %% 当 Ra_switch==2时，需要自己输入 表面形貌参数
end
%% 将滑动轴承进行分段
global_Length=[390];
global_para=bearing_split(global_Length,global_para);
%% 修形
% global profile_point
profile_point=[];
bearing_num=global_para.split_para.bearing_num;
for I=1:bearing_num
    profile_point{I}=linspace(0,0,ny);
end
% 将参数储存到 global_para 中
global_para.shaping.profile_point=profile_point;
%% 弹性变形
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
    [U,single_L]=initialize(nx,ny,nz,maxlev,gama,Rqb,Rqs,global_para.structure_para.C0/1E3);
    L{I}=single_L;
end
for level=maxlev:-1:1
    [U,L]=init_uf(U,L,global_para,level,global_para.initial_para.epsilon);
end
%% 流固热耦合的循环计算
global_temp_error=1;
M_new=1;
M_angle_curve=1;
while global_temp_error>1E-6
%     old_global_p_1=L{maxlev,6};    % Note
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
    end
    unit_p=L{maxlev,6}/Pdim;      % 单位：Pa
    unit_h=L{maxlev,7}*C0;
    %% 温度计算(压力已经测试完毕，下边开始测试温度部分)
    if global_para.switch.DENVIS_switch==0
        global_temp_error=0;
    else
        %% 温度值计算
        [U,L]=temp(U,L,CFO,FKO);
        %% 计算温度影响前后的压力误差
        new_global_p=L{maxlev,6};
        global_temp_error=abs(sum(sum(new_global_p))-sum(sum(old_global_p)))/sum(sum(new_global_p));
        fprintf('\n计算温度后的压力误差为：%e',global_temp_error);
    end
end
output(U,L,maxlev,CR*Rshaft/1E3,Vis,Um,Rbearing,Length,Wkn);
T=L{1,19};
unit_T=T*T0-273.15;