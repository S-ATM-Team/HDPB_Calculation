function [U,L,global_para]=relaxh0(U,L,k,global_para)
%% 释放参数
calculation_mode=global_para.switch.calculation_mode;
M_switch=global_para.switch.M_switch;
Ra_switch=global_para.switch.Ra_switch;
titling1=global_para.initial_para.titling1;
titling2=global_para.initial_para.titling2;
part_Length=global_para.split_para.part_Length;
bearing_num=global_para.split_para.bearing_num;
Wkn=global_para.work_condition.Wkn;
part_p_error=global_para.result.part_p_error;
Length_point=global_para.split_para.Length_point;
%%
AttiAng=global_para.middle_para.AttiAng;
epsilon=global_para.initial_para.epsilon;
Msc=global_para.work_condition.Msc;
%%
Length=global_para.structure_para.Length;
Rbearing=global_para.structure_para.Rbearing;
C0=global_para.structure_para.C0;
%%
Pdim=global_para.middle_para.Pdim;
%%
G_coef_W=global_para.iteration_para.G_coef_W;
G_coef_M=global_para.iteration_para.G_coef_M;
G_coef_M_angle=global_para.iteration_para.G_coef_M_angle;
%%
non_unit_deformation_oil_film=global_para.deform.non_unit_deformation_oil_film;
profile_point=global_para.profile_para.profile_point;
%%
W_new=0;
W_new_x=0;
W_new_y=0;
for floor_num=1:bearing_num
    p=L{floor_num}{k,6};
    h=L{floor_num}{k,7};
    ii=L{floor_num}{k,3};
    jj=L{floor_num}{k,4};
    hx=L{floor_num}{k,1};
    hy=L{floor_num}{k,2};
    single_Length=part_Length(floor_num);
    %% 粗糙峰接触计算
    p_asp=zeros(ii,jj);
%     unit_Rs=U.Rs*C0*1E-3;       % C0的单位为 mm，将单位转化为 m
%     if Ra_switch==1
%         for I=1:ii
%             for J=1:jj
%                 single_HbR=h(I,J)/U.Rs;
%                 if single_HbR<4
%                     single_F2p5=interp1(HbR,F2p5,single_HbR);
%                 else
%                     single_F2p5=0;
%                 end
%                 p_asp(I,J)=8*pi/5*Kp*para_Ra*single_F2p5;
%             end
%         end
%     elseif Ra_switch==2
%         
%     end
%     p_asp=p_asp*1E6;    % 将 Pa 单位 转化为 MPa单位
%     gp=p+p_asp;
    L{floor_num}{k,25}=p_asp;
    %% 计算载荷
    unit_p=(p+p_asp)/Pdim;      % 单位：Pa
    for I=2:ii-1
        for J=2:jj-1
            if p(I,J)>0
                %% 径向载荷
                W_new_x=W_new_x+unit_p(I,J)*sin(U.xa+(I-1)*hx)*hy*hx;
                W_new_y=W_new_y+unit_p(I,J)*cos(U.xa+(I-1)*hx)*hy*hx;
            end
        end
    end
end
W_new_x=W_new_x*Rbearing*1E-3*single_Length*1E-3;
W_new_y=W_new_y*Rbearing*1E-3*single_Length*1E-3;
W_new=sqrt(W_new_x^2+W_new_y^2);
W_new=W_new/1E3;
AttiAng=atan(abs(W_new_x/W_new_y));
%% 迭代计算
if calculation_mode==1
    epsilon=epsilon+0.003*G_coef_W*(abs(Wkn/W_new)-1);   % 发生固体接触后，使偏心率的变化减小
elseif calculation_mode==0
    epsilon=epsilon;
end
if epsilon>=1
    epsilon=0.8;
end


%%

%% 固体+油膜部分的计算
% sx=0;
% sy=0;
% for I=2:ii-1
%     for J=2:jj-1
%         if gp(I,J)>0
%             sy=sy+gp(I,J)*cos((I-1)*hx);
%             sx=sx+gp(I,J)*sin((I-1)*hx);
%         end
%     end
% end
% sx=sx*hx*hy;
% sy=sy*hx*hy;
% 
% swx=sy*sin(AttiAng)+sx*cos(AttiAng);
% swy=sy*cos(AttiAng)-sx*sin(AttiAng);
% 
% rg=L{k,23};
% w=sqrt(swx^2+swy^2);
%%
%-------------------------加上弯矩之后需要平衡角度和弯矩------------------------------------%
M_new=0;
M_new_x=0;
M_new_y=0;
M_angle_curve=1;
if M_switch==1
    err_pressure_part=sum(part_p_error(:));
    if err_pressure_part<1E-3
        for floor_num=1:bearing_num
            ii=L{floor_num}{1,3};
            jj=L{floor_num}{1,4};
            p=L{floor_num}{k,6};
            unit_p=(p+p_asp)/Pdim;      % 单位：Pa
            DX=2*pi/ii;
            Dy=part_Length(floor_num)*1E-3/(jj-1);
            for I=1:ii
                SETA=(I-1)*DX;
                for J=1:jj
                    distance_axial=Dy*(J-1)-Length*1E-3/2+Length_point(2*floor_num-1)*1E-3;
                    M_new_x=M_new_x+unit_p(I,J)*cos(SETA)*DX*Dy*Rbearing*1E-3*distance_axial;
                    M_new_y=M_new_y+unit_p(I,J)*sin(SETA)*DX*Dy*Rbearing*1E-3*distance_axial;
                end
            end
        end
        M_old=M_new;
        M_new=sqrt(M_new_x^2+M_new_y^2);
        M_angle=atand(abs(M_new_x/M_new_y));
        M_angle_curve_old=M_angle_curve;
        M_angle_curve=M_angle*2*pi/360;
        M_ratio=Msc/M_new;
        if M_ratio>10
            M_ratio=10;
        end
        titling1_old=titling1;
        titling2_old=titling2;
        if isempty(find(p_asp>max(max(p))))==1
            titling1=titling1+1E-5*G_coef_M*(M_ratio-1);
            titling2=titling2-1E-3*G_coef_M_angle*(AttiAng/M_angle_curve-1);
        else
            titling1=titling1+1E-5*G_coef_M*(M_ratio-1);
            titling2=titling2-1E-3*G_coef_M_angle*(AttiAng/M_angle_curve-1);
        end
    end
    %% 检测油膜厚度是否合理
    oil_test=0;
    epsilon_old=epsilon;
    while 1
        judge_num=0;
        for floor_num=1:bearing_num
            ii=L{floor_num}{1,3};
            jj=L{floor_num}{1,4};
            kk=L{floor_num}{1,5};
            single_non_unit_deformation_oil_film=non_unit_deformation_oil_film{floor_num};
            single_profile_point=profile_point{floor_num};
            start_point=2*floor_num-1;
            end_point=2*floor_num;
            yy=linspace(Length_point(start_point),Length_point(end_point),jj);
            for I=1:ii
                x=U.xa+(I-1)*L{floor_num}{1,1};
                for J=1:jj
                    L{floor_num}{1,7}(I,J)=oil_film_thickness(x,epsilon,yy(J),single_non_unit_deformation_oil_film(I,J),single_profile_point(1,J),titling1,titling2,Length,C0);
                end
            end
            minh=min(min(L{floor_num}{1,7}));
            if minh<0
                judge_num=1;
            end
        end
        if judge_num==1
            epsilon=epsilon_old+0.003*G_coef_W*(abs(Wkn/W_new)-1);   % 此时没有固体接触
            titling1=titling1_old+1E-5*G_coef_M*(M_ratio-1);
            titling2=titling2_old-1E-3*G_coef_M_angle*(AttiAng/M_angle_curve-1);
            G_coef_W=G_coef_W*0.5;
            G_coef_M=G_coef_M*0.5;
            G_coef_M_angle=G_coef_M_angle*0.5;
        else
            break;
        end
    end
end
%% 将部分参数重新储存
global_para.initial_para.epsilon=epsilon;
global_para.initial_para.titling1=titling1;
global_para.initial_para.titling2=titling2;
%
global_para.middle_para.AttiAng=AttiAng;
%
global_para.iteration_para.G_coef_W=G_coef_W;
global_para.iteration_para.G_coef_M=G_coef_M;
global_para.iteration_para.G_coef_M_angle=G_coef_M_angle;
%
global_para.result.M_new=M_new;
global_para.result.M_angle_curve=M_angle_curve;
end