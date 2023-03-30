%% �Ų�ʿ---����������⻬�����ѹ����
% ���еĲ����������� global_para �У�
% �����Ĳ���������U�У���Ҫ�ֲ�Ĳ���ȫ�����浽 L ��
clear;
clc;
%% ��������
% �ṹ����
global_para.structure_para.Rbearing=160;   % ��а뾶 mm
global_para.structure_para.Length=390;     % ��г��� mm
global_para.structure_para.CR=0.001;       % ��϶�� ������
global_para.structure_para.Rshaft=global_para.structure_para.Rbearing/(1+global_para.structure_para.CR);   % �ᾱ�뾶 mm
global_para.structure_para.C0=global_para.structure_para.Rbearing-global_para.structure_para.Rshaft;             % �뾶��϶ mm

gama=1;        % �ֲڶȷ��� ������
Rqb=0.2;       % ��б���Ĵֲڶ� um
Rqs=0.2;       % �ᾱ����Ĵֲڶ� um

% ��������
Fr=0;       % ����ѹ���� Fy N
Ft=704125;       % ������ Fz N
Fax=99000;      % ������ Fx N
pitch_circle_radius=247.12;    % ���ֽ�Բ�뾶 mm
global_para.work_condition.Wkn=2*Ft*1E-3;         % Wkn�ĵ�λΪ KN��Ft�ĵ�λΪ N
global_para.work_condition.Msc=2*Fax*pitch_circle_radius*1E-3;     % N��m ��ż�صļ��㹫ʽΪ ƽ�����е�һ������ƽ����֮����루����ż�ۣ��ĳ˻�
global_para.work_condition.RS=29;         % �ᾱ/���ת�� rpm
global_para.work_condition.Vis=0.2768;            % ���͵�ճ�ȣ�Pa*s��
global_para.work_condition.DENO=860;             % ���͵��ܶȣ�kg/m^3��
global_para.work_condition.CFO=2000;             % ���͵ı����ݣ�J/kg*��C��
global_para.work_condition.FKO=0.13;             % ���͵ĵ���ϵ��
%% �������(����Ҫ���п�����صļ��㣬����ֻ��ʹ��һ������)
maxlev=1;
ncy=10;
nx = 101;
ny = 41;
nz = 11;         % ��Ĥ������������������
%% ��ʼ����
% ƫ����
global_para.initial_para.epsilon=0.7;

% �ᾱ��б�������ǶȲ���:titling1Ϊ----��titling2Ϊ----
% global titling1 titling2
global_para.initial_para.titling1=0*2*pi/360;       % gama���ᾱ������е���б��
global_para.initial_para.titling2=00*2*pi/360;     % alfa��OC2��C1C3֮��ļн�

% �¶�
global_para.initial_para.T0=273.15+40;
% ����ʼ�������浽 global_para ��
% global_para.initial_para.epsilon=epsilon;
% global_para.initial_para.titling1=titling1;
% global_para.initial_para.titling2=titling2;
%% ����ģʽ
% �Ƿ����¶ȶ��ܶȺ�ճ�ȵ�Ӱ��
% global DENVIS_switch
global_para.switch.DENVIS_switch=0;

% Elastic_deform_switchΪ�Ƿ��ǵ��Ա��ε�Ӱ�죨�����ţ�
% global Elastic_deform_switch

% 1���̶��غɼ��㣻0���̶�ƫ���ʼ���
% global calculation_mode
global_para.switch.calculation_mode=1;

% 1���̶���ش�С��0���̶��ᾱλ��
% global M_switch M_new M_angle_curve
global_para.switch.M_switch=0;

% �Ƿ��Ǵֲڶ�
% global Ra_switch Kp para_Ra HbR F2p5
global_para.switch.Ra_switch=0;
Ra_switch=global_para.switch.Ra_switch;
if Ra_switch==0
    gama=0;
    Rqb=1E-12;
    Rqs=1E-12;
elseif Ra_switch==1
    %% �� Ra_switch==1ʱ������ֲڷ�������from THE CONTACT OF TWO NOMINALLY FLAT ROUGH SURFACES
    Kp=1000*0.098;   % ����λ kgf/cm^2 ת��Ϊ��λΪ MPa
    para_Ra=0.05;
    HbR=[0,0.5,1,1.5,2,2.5,3,3.5,4];
    F2p5=[0.61664,0.24040,0.08056,0.02286,0.00542,0.00106,0.00017,0.00002,0];
elseif Ra_switch==2
    %% �� Ra_switch==2ʱ����Ҫ�Լ����� ������ò����
end
%% ��������н��зֶ�
global_Length=[390];
global_para=bearing_split(global_Length,global_para);
%% ����
% global profile_point
profile_point=[];
bearing_num=global_para.split_para.bearing_num;
for I=1:bearing_num
    profile_point{I}=linspace(0,0,ny);
end
% ���������浽 global_para ��
global_para.shaping.profile_point=profile_point;
%% ���Ա���
non_unit_deformation_oil_film=[];
for I=1:bearing_num
    non_unit_deformation_oil_film{I}=zeros(nx,ny);
end
global_para.deform.non_unit_deformation_oil_film=non_unit_deformation_oil_film;
%%
Um = (2.0 * pi * global_para.work_condition.RS/ 60) * (global_para.structure_para.Rshaft / 1e3);    % �ᾱ�����ߵ�����ٶ� m/s
Pdim=(global_para.structure_para.Rshaft/1e3*global_para.structure_para.CR)^2/(6.0*global_para.work_condition.Vis*Um*global_para.structure_para.Rbearing/1e3);


AttiAng = atan(pi / 4 * sqrt(1 - global_para.initial_para.epsilon^2) / global_para.initial_para.epsilon);
%
global_para.middle_para.Um=Um;
global_para.middle_para.Pdim=Pdim;
global_para.middle_para.AttiAng=AttiAng;
%% ����״̬���̲���
global_para=state_equation_para(global_para);
%%
for I=1:bearing_num
    [U,single_L]=initialize(nx,ny,nz,maxlev,gama,Rqb,Rqs,global_para.structure_para.C0/1E3);
    L{I}=single_L;
end
for level=maxlev:-1:1
    [U,L]=init_uf(U,L,global_para,level,global_para.initial_para.epsilon);
end
%% ��������ϵ�ѭ������
global_temp_error=1;
M_new=1;
M_angle_curve=1;
while global_temp_error>1E-6
%     old_global_p_1=L{maxlev,6};    % Note
    global_para.iteration_para.G_coef_W=1;
    global_para.iteration_para.G_coef_M=1;
    global_para.iteration_para.G_coef_M_angle=1;
    %% ��Ĥѹ������
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
    unit_p=L{maxlev,6}/Pdim;      % ��λ��Pa
    unit_h=L{maxlev,7}*C0;
    %% �¶ȼ���(ѹ���Ѿ�������ϣ��±߿�ʼ�����¶Ȳ���)
    if global_para.switch.DENVIS_switch==0
        global_temp_error=0;
    else
        %% �¶�ֵ����
        [U,L]=temp(U,L,CFO,FKO);
        %% �����¶�Ӱ��ǰ���ѹ�����
        new_global_p=L{maxlev,6};
        global_temp_error=abs(sum(sum(new_global_p))-sum(sum(old_global_p)))/sum(sum(new_global_p));
        fprintf('\n�����¶Ⱥ��ѹ�����Ϊ��%e',global_temp_error);
    end
end
output(U,L,maxlev,CR*Rshaft/1E3,Vis,Um,Rbearing,Length,Wkn);
T=L{1,19};
unit_T=T*T0-273.15;