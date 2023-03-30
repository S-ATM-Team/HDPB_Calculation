function [U,L,global_para]=interation_solver(global_para)
%% patch
global_para.result.num=1;
%% ���ƽṹ����
global_para.structure_para.Rshaft=global_para.structure_para.Rbearing/(1+global_para.structure_para.CR);   % �ᾱ�뾶 mm
global_para.structure_para.C0=global_para.structure_para.Rbearing-global_para.structure_para.Rshaft;             % �뾶��϶ mm
%% ���ƹ�������
global_para.work_condition.Wkn=2*global_para.work_condition.Fz*1E-3;         % Wkn�ĵ�λΪ KN��Ft�ĵ�λΪ N
global_para.work_condition.Msc=2*global_para.work_condition.Fx*global_para.work_condition.bearing_pitch_radius*1E-3;     % N��m ��ż�صļ��㹫ʽΪ ƽ�����е�һ������ƽ����֮����루����ż�ۣ��ĳ˻�
%% ��ʼ ���͵��� ����
if global_para.work_condition.bearing_oil_type==1
    if global_para.switch.DENVIS_switch==1
        %% �����ձ�׼�ļ������̽��й�ʽ����ʱ����Ҫ���� ע���¶� ��ǰ�����������͵���
%         global_para.result.T_ex0=global_para.temp_calculation.inlet_temp+20;
%         global_para.result.T_ex1=0;
%         global_para.work_condtion.Vis=vis(0.5*(global_para.result.T_ex0+global_para.temp_calculation.inlet_temp));
        global_para.work_condition.Vis=vis(global_para.temp_calculation.T_envir);
    elseif global_para.switch.DENVIS_switch==2
        %% ���ձ�׼�����м��㣬ֱ�Ӱ��� �����¶ȼ��㼴�ɣ����ÿɲ��ã�
        global_para.work_condition.Vis=vis(global_para.temp_calculation.T_envir);
    elseif global_para.switch.DENVIS_switch==3
        %% ��ά�����¶ȳ�����
        global_para.work_condition.Vis=vis(global_para.temp_calculation.T_envir);
    end
elseif global_para.work_condition.bearing_oil_type==2
    %% ��ѡ��2ʱ����д���󻬽��ʵ��Ⱦ��Ǹû����¶��µ���
    if global_para.switch.DENVIS_switch==1
        %% �����ձ�׼�ļ������̽��й�ʽ����ʱ����Ҫ���� ע���¶� ��ǰ�����������͵���
%         global_para.result.T_ex0=global_para.temp_calculation.inlet_temp+20;
%         global_para.result.T_ex1=0;
%         TT=0.5*(global_para.result.T_ex0+global_para.temp_calculation.inlet_temp);
%         global_para.work_condition.Vis=global_para.work_condition.Vis*exp(log(global_para.work_condition.Vis+9.67)*(((TT+273.15-138)/(global_para.temp_calculation.T_envir+273.15-138))^(-1.1)-1));

    end
elseif global_para.work_condition.bearing_oil_type==3
    if global_para.switch.DENVIS_switch==1
    elseif global_para.switch.DENVIS_switch==2
        %% ���ձ�׼�����м��㣬ֱ�Ӱ��� �����¶ȼ��㼴�ɣ����ÿɲ��ã�
        global_para.work_condition.Vis=vis_100(global_para.temp_calculation.T_envir);
    elseif global_para.switch.DENVIS_switch==3
        %% ��ά�����¶ȳ�����
        global_para.work_condition.Vis=vis_100(global_para.temp_calculation.T_envir);
    end
end
%% ���Ƽ���ģʽ
if global_para.work_condition.Msc==0
    global_para.switch.M_switch=0;
    %% �����û����أ�Ҳ������Ҫ����ƫ���ʣ�����Ҫ�ر���е���б
    if global_para.switch.calculation_mode==1
        global_para.initial_para.titling1=0;
        global_para.initial_para.titling2=0;
    end
else
    global_para.switch.M_switch=1;
end
%% ������� ���������ֻ��ʹ��һ������
maxlev=1;
ncy=10;
nx = 101;
ny = 41;
nz = 11;         % ��Ĥ������������������
%% ����Ҫ�����������ڣ��ֲڷ壩
gama=1;        % �ֲڶȷ��� ������
Rqb=0.2;       % ��б���Ĵֲڶ� um
Rqs=0.2;       % �ᾱ����Ĵֲڶ� um

global_para.switch.Ra_switch=0;
%% ��зֶ�
bearing_num=global_para.split_para.bearing_num;
global_para=bearing_split_para(global_para);
%% ���β������Ȳ���Ĭ�����������ٰѽ����е����β������룩
global_para=bearing_profile_shaping(global_para,ny);
%% ���Ա��γ�ʼ��
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
    [U,single_L]=initialize(nx,ny,nz,maxlev,gama,Rqb,Rqs,global_para.structure_para.C0/1E3,global_para.switch.DENVIS_switch,global_para.temp_calculation.T_envir,global_para);
    L{I}=single_L;
end
for level=maxlev:-1:1
    [U,L]=init_uf(U,L,global_para,level,global_para.initial_para.epsilon);
end
%% ѭ������
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
    %% ���þ��ȼ���---Ҫ��������������Ϊ�������̣�ֻ�е�DENVIS_switch==1ʱ�Ż���Ҫ��һ����
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
        %% ������Ĥ��ȷֲ�
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
    %% �� ��Ĥѹ�� �� ��Ĥ��� �Լ� ��Ӧ�� X��Y ���걣�浽txt�ļ���
%     unit_p=L{1}{maxlev,6}/Pdim;      % ��λ��Pa
%     unit_h=L{1}{maxlev,7}*C0;
%     write_txt(unit_p,unit_h)
    %% �¶ȼ���(ѹ���Ѿ�������ϣ��±߿�ʼ�����¶Ȳ���)
    if global_para.switch.DENVIS_switch==0
        global_temp_error=0;
    else
        %% �¶�ֵ����
        [U,L,global_para]=temp(U,L,global_para);
        %% �����¶�Ӱ��ǰ���ѹ�����
        for floor_num=1:bearing_num
            new_global_p{floor_num}=L{floor_num}{1,6};
            global_temp_error=global_temp_error+abs(sum(sum(new_global_p{floor_num}))-sum(sum(old_global_p{floor_num})))/sum(sum(new_global_p{floor_num}));
        end
        %% ������ձ�׼����,����Ҳ��Ҫ���е�������
%         if global_para.switch.DENVIS_switch==2
%             global_temp_error=0;
%         end
        fprintf('\n�����¶Ⱥ��ѹ�����Ϊ��%e',global_temp_error);
    end
end
end