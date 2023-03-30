function [U,L]=TVISDEN(U,L,k,global_para)
%%
ii=L{1,3};
jj=L{1,4};
kk=L{1,5};
p=L{1,6};
%% 
T=L{1,19};
%%
VIS=L{1,17};
DEN=L{1,18};
%% 参数释放
A1=global_para.state_equation.A1;
A2=global_para.state_equation.A2;
A3=global_para.state_equation.A3;
A4=global_para.state_equation.A4;

CL1=global_para.state_equation.CL1;
CL2=global_para.state_equation.CL2;
CL3=global_para.state_equation.CL3;

Z0=global_para.state_equation.Z0;
S0=global_para.state_equation.S0;
%%
DENVIS_switch=global_para.switch.DENVIS_switch;
%%
if DENVIS_switch==0
    VIS=ones(ii,jj,kk);
    DEN=ones(ii,jj,kk);
elseif DENVIS_switch==3
    if global_para.work_condition.bearing_oil_type==1
        DEN=ones(ii,jj,kk);
        for I=1:ii
            for J=1:jj
                for K=1:kk
                    stand_T=T(I,J,K);
                    standard_T=(stand_T*(273.15+global_para.temp_calculation.T_envir))-273.15;
                    VIS(I,J,K)=vis(standard_T)/global_para.work_condition.Vis;
                end
            end
        end
    elseif global_para.work_condition.bearing_oil_type==2
        for I=1:ii
            for J=1:jj
                for K=1:kk
                    TE1=(1+A2*p(I,J))^Z0;
                    TE3=(A3*T(I,J,K)-A4)^(-S0);
                    VIS(I,J,K)=exp(A1*(-1+TE1*TE3));
                    
                    TE2=CL1*p(I,J)/(1+CL2*p(I,J));
                    TE4=CL3*(T(I,J,K)-1);
                    DEN(I,J,K)=1+TE2-TE4;
                end
            end
        end
    end
elseif (DENVIS_switch==1)
    %% 调出标准计算出来的温度的黏度值进行计算
    DEN=ones(ii,jj,kk);
    stand_T=T(1,1,1);
    if global_para.work_condition.bearing_oil_type==1
        %% 计算油温
        standard_T=(stand_T*(273.15+global_para.temp_calculation.T_envir))-273.15;
        %% 计算油温下的黏度值/初始油温下的黏度值
        VIS=vis(standard_T)/global_para.work_condition.Vis*ones(ii,jj,kk);
    elseif global_para.work_condition.bearing_oil_type==3
        %% 计算油温(ISO VG 100)
        standard_T=(stand_T*(273.15+global_para.temp_calculation.T_envir))-273.15;
        %% 计算油温下的黏度值/初始油温下的黏度值
        VIS=vis_100(standard_T)/global_para.work_condition.Vis*ones(ii,jj,kk);
    else
        Vis_T=global_para.work_condition.Vis*exp(log(global_para.work_condition.Vis+9.67)*(((stand_T*(273.15+global_para.temp_calculation.T_envir)-138)/(global_para.temp_calculation.T_envir+273.15-138))^(-1.1)-1));
        VIS=Vis_T/global_para.work_condition.Vis*ones(ii,jj,kk);
    end
elseif (DENVIS_switch==2)
    DEN=ones(ii,jj,kk);
    stand_T=T(1,1,1);
    if global_para.work_condition.bearing_oil_type==1
        %% 计算油温
        standard_T=(stand_T*(273.15+global_para.temp_calculation.T_envir))-273.15;
        %% 计算油温下的黏度值/初始油温下的黏度值
        VIS=vis(standard_T)/global_para.work_condition.Vis*ones(ii,jj,kk);
    elseif global_para.work_condition.bearing_oil_type==3
        %% 计算油温(ISO VG 100)
        standard_T=(stand_T*(273.15+global_para.temp_calculation.T_envir))-273.15;
        %% 计算油温下的黏度值/初始油温下的黏度值
        VIS=vis_100(standard_T)/global_para.work_condition.Vis*ones(ii,jj,kk);
    else
        Vis_T=global_para.work_condition.Vis*exp(log(global_para.work_condition.Vis+9.67)*(((stand_T*(273.15+global_para.temp_calculation.T_envir)-138)/(global_para.temp_calculation.T_envir+273.15-138))^(-1.1)-1));
        VIS=Vis_T/global_para.work_condition.Vis*ones(ii,jj,kk);
    end
end
%% 更新元胞数组L
L{1,17}=VIS;
L{1,18}=DEN;
end