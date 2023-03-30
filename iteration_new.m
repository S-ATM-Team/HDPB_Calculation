function [T_B,h_min,So,beta,T_ex1,Q,psi_eff,psi_bar,epsilon,f,global_para]=iteration_new(T_en,D,N_B,N_J,B,CR,F,T_amb,d_l,p_en,cal_type,HolePosition,global_para)
% [T_B,h_min,So,beta,T_ex1,Q,psi_eff,psi_bar,epsilon,f,global_para]=iteration_new(T_en,delta_min,delta_max,D,alpha_IB,alpha_IJ,N_B,N_J,B,F,T_amb,k_A,A,d_l,p_en,cal_type,HolePosition,global_para)
%% 周向油槽补丁
if HolePosition==3
    bG=(global_para.structure_para.Length-global_para.split_para.bearing_single_Length*global_para.split_para.bearing_num)/(global_para.split_para.bearing_num-1)*1E-3;
    num_oil_groove=global_para.split_para.bearing_num-1;
    if global_para.split_para.bearing_num~=1
        F=F/global_para.split_para.bearing_num;
        B=global_para.split_para.bearing_single_Length*1E-3;
    end
else
    num_oil_groove=1;
end
%%
%% convection
if cal_type==1
    T_B0 = T_en;
    T_B=0;
    i=0;

    while abs(T_B-T_B0)>1
        if i>0
            T_B0=T_B;
        end
        eta_eff = vis(T_B0);
        if eta_eff==0
            break;
        end
        i=i+1;
        psi_bar = 0.5*(delta_min/D+delta_max/D)*2;

        psi_delta = (alpha_IB-alpha_IJ)*(T_B0-20);
        psi_eff = psi_bar+psi_delta;
        
        omega_B = 2*pi*N_B;
        omega_J = 2*pi*N_J;
        omega_h = omega_B+omega_J;
        
        So = F*psi_eff^2/D/B/eta_eff/omega_h;
        
        if So>1
            epsilon = curvefitting(So,B/D,1);
            beta = curvefitting(So,B/D,4);
            f = curvefitting(So,B/D,2)*psi_eff;
        else
            epsilon = interpolate(So,B/D,1);
            beta = interpolate(So,B/D,4);
            f = interpolate(So,B/D,2)*psi_eff;
        end
        
        h_min = 0.5*D*psi_eff*(1-epsilon);
        
        P_thf = f*F*D/2*omega_h;
        
        T_B1 = T_amb + P_thf/k_A/A;
        T_B=T_B0*0.8+0.2*(T_B1);
    end
end

%% lubricant
if cal_type==2
    T_ex0 = T_en +20;
    T_ex1 = 0;
    i=0;
    count = 0;
    while abs(T_ex0-T_ex1)>1
        count = count +1;
        if i>0
            T_ex0 = 0.5*T_ex1+0.5*T_ex0;
        end
        i=1;
        T_B = 0.5*(T_ex0+T_en);
        if global_para.work_condition.bearing_oil_type==1
            eta_eff = vis(T_B);
        elseif global_para.work_condition.bearing_oil_type==2
            eta_eff = global_para.work_condition.Vis*exp(log(global_para.work_condition.Vis+9.67)*(((T_B+273.15-138)/(global_para.temp_calculation.T_envir+273.15-138))^(-1.1)-1));
        elseif global_para.work_condition.bearing_oil_type==3
            eta_eff = vis_100(T_B);
        end
        if eta_eff==0
            break;
        end
        psi_bar=0;
%         psi_bar = (delta_min/D+delta_max/D);
%         psi_delta = (alpha_IB-alpha_IJ)*(T_B-20);
        psi_eff = CR;
        
        omega_B = 2*pi*N_B;
        omega_J = 2*pi*N_J;
        omega_h = omega_B+omega_J;
        
        So = F*psi_eff^2/D/B/eta_eff/omega_h;
        
        if So>0
            epsilon = curvefitting(So,B/D,1);
            beta = curvefitting(So,B/D,4);
            f = curvefitting(So,B/D,2)*psi_eff;   % 该值为 fp
            Q3 = D^3*psi_eff*omega_h*curvefitting(So,B/D,3);
        else
            epsilon = interpolate(So,B/D,1);
            beta = interpolate(So,B/D,4);
            f = interpolate(So,B/D,2)*psi_eff;    % 该值为 fp
            Q3 = D^3*psi_eff*omega_h*interpolate(So,B/D,3);
        end

        h_min = 0.5*D*psi_eff*(1-epsilon);
        %% 周向油槽/其他情况
        DEN=900;
        hG=global_para.temp_calculation.hG*1E-3;   % 润滑油腔深度
        if HolePosition==3
            %% 周向油槽时计算摩擦产生的热流量需要采用一些特殊的方法
            Re_G=DEN*omega_h*hG*D/(2*eta_eff);
            epsilion_G=0.5*2*pi*(4+0.0012*Re_G^0.94);
            Ffp=eta_eff*omega_h*D*B/(CR)*((f/psi_eff)*So-bG/B*(2*pi/(2*sqrt(1-epsilon^2))-psi_eff*D*epsilion_G/(2*hG)));
            P_thf=Ffp*D/2*omega_h;
        else
            P_thf = f*F*D/2*omega_h;
        end
        %% 油孔供油——固定进油压力/进油量
        if global_para.temp_calculation.heat_type==1
            %         q_L = 1.188+1.582*(d_l/B)-2.585*(d_l/B)^2+5.563*(d_l/B)^3;
            q_L = 1.204+0.368*(d_l/B)-1.046*(d_l/B)^2+1.942*(d_l/B)^3;
            if HolePosition==1
                %% 轴承载荷反向位置单油孔供油，此时轴承包角为360°
                Q_Px = pi/48/log(B/d_l)/q_L*(1+epsilon)^3;
            elseif HolePosition==3
                Q_Px = pi/24*(1+1.5*epsilon^2)/(global_para.structure_para.Length*1E-3/d_l)*global_para.structure_para.Length*1E-3/(global_para.structure_para.Length*1E-3-bG);
            elseif HolePosition==2
                errordlg('双侧进油记得删除');
            end
            Q_P=Q_Px*(D^3*psi_eff^3*p_en/eta_eff)*num_oil_groove;
        else
            Q_P=global_para.temp_calculation.inlet_flow/60/1000;
        end
        %%
        Q = Q3+Q_P;
        %% 1.8E6（密度*比热容）为矿物油参数
        T_ex1 = T_en + P_thf/1.8e6/Q;
        
        if count ==14
            temp = T_B;
        end
        if count ==15
            T_B = 0.5*temp+0.5*T_B;
            break;
        end
    end
    
end
end