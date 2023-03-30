function [U,L,global_para]=TEMPER(U,L,global_para)
%%
global T ii jj kk hx hy h RoL CLS1 CLS2 T0
global DEN VIS DZ Q UU VV DUDZ DVDZ OMIGT
%% 进油温度
inlet_temp=global_para.temp_calculation.T_inlet;   % 单位为 °
T_envir=global_para.temp_calculation.T_envir;   % 单位为 °
inlet_flow=global_para.temp_calculation.flow;   % 单位为 L/min
non_unit_inlet_temp=(inlet_temp+273.15)/(T_envir+273.15);
%% 计算DPDX和DPDY
PARTF()
%%
C2=1;
DZ=1/(kk-1);
while C2>1E-6
    ERRTA=0;
    SUMTA=0;
    %% 储存上次的计算温度
    TOLD=T;
    %% 迭代密度和黏度
    TVISDEN(U,L,1,global_para);
    %% 参数释放
    VIS=L{1,17};
    DEN=L{1,18};
    %% 计算润滑介质的流速
    UVCAL();
    %%
    QCAL();
    flowrate=Temp_Leakage(global_para);
    %% 计算油膜初始位置处的无量纲温度值
    i=1;
    for j=1:jj
        for k=2:kk-1
            T(i,j,k)=inlet_flow/flowrate*non_unit_inlet_temp+(flowrate-inlet_flow)/flowrate*T(ii-1,j,k);
%             T(end,j,k)=T(i,j,k);
        end
    end
    %% 开始计算
    for i=2:ii
        for j=1:jj
            if i==1
%                 HIJ=h(i,j)^2;
%                 RHDZS=1/(h(i,j)*DZ)^2;
%                 for k=2:kk-1
%                     STA(k-1,1)=0;
%                     STA(k-1,2)=0;
%                     STA(k-1,3)=0;
%                     STB(k-1)=0;
%                 end
%                 
%                 if j==ceil(jj/2)
%                     
%                 else
%                     for k=2:kk-1
%                         if UU(i,j,k)>=0
%                             STA(k-1,2)=1;
%                             STB(k-1)=1;
%                         else
%                             STA(k-1,1)=-(RHDZS+0.5*CLS1*Q(i,j,k)/DZ);
%                             STA(k-1,2)=2*RHDZS-CLS1*DEN(i,j,k)*UU(i,j,k)/hx;
%                             STA(k-1,3)=-(RHDZS-0.5*CLS1*Q(i,j,k)/DZ);
%                             STB(k-1)=-CLS1*DEN(i,j,k)*UU(i,j,k)*T(i+1,j,k)/hx+CLS2*VIS(i,j,k)/HIJ*(DUDZ(i,j,k)^2+DVDZ(i,j,k)^2);
%                         end
%                         if j==1 || j==jj
%                             if j==1
%                                 STA(k-1,2)=STA(k-1,2)-CLS1*RoL*DEN(i,j,k)*VV(i,j,k)/hy;
%                                 STB(k-1)=STB(k-1)-CLS1*RoL*DEN(i,j,k)*VV(i,j,k)*T(i,j+1,k)/hy;
%                             else
%                                 STA(k-1,2)=STA(k-1,2)+CLS1*RoL*DEN(i,j,k)*VV(i,j,k)/hy;
%                                 STB(k-1)=STB(k-1)+CLS1*RoL*DEN(i,j,k)*VV(i,j,k)*T(i,j-1,k)/hy;
%                             end
%                         else
%                             if VV(i,j,k)<0
%                                 STA(k-1,2)=STA(k-1,2)-CLS1*RoL*DEN(i,j,k)*VV(i,j,k)/hy;
%                                 STB(k-1)=STB(k-1)-CLS1*RoL*DEN(i,j,k)*VV(i,j,k)*T(i,j+1,k)/hy;
%                             else
%                                 STA(k-1,2)=STA(k-1,2)+CLS1*RoL*DEN(i,j,k)*VV(i,j,k)/hy;
%                                 STB(k-1)=STB(k-1)+CLS1*RoL*DEN(i,j,k)*VV(i,j,k)*T(i,j-1,k)/hy;
%                             end
%                         end
%                     end
%                 end
%                 
%                 STB(1)=STB(1)-STA(1,1)*T(i,j,1);
%                 STB(kk-2)=STB(kk-2)-STA(kk-2,3)*T(i,j,kk);
%                 %% 通过追赶法计算温度
%                 matrix_STA=zeros(kk-2,kk);
%                 matrix_STB=zeros(kk-2,1);
%                 for k=2:kk-1
%                     start_pos=k-1;
%                     end_pos=k+1;
%                     matrix_STA(k-1,start_pos:end_pos)=STA(k-1,:);
%                     matrix_STB(k-1)=STB(k-1);
%                 end
%                 matrix_STA(:,1)=[];
%                 matrix_STA(:,end)=[];
%                 TK=linsolve(matrix_STA,matrix_STB);
%                 %%
%                 for k=2:kk-1
%                     if TK(k-1)<1
%                         TK(k-1)=1;
%                     end
%                     T(i,j,k)=TK(k-1);
%                 end
            else
                HIJ=h(i,j)^2;
                RHDZS=1/(h(i,j)*DZ)^2;
                for k=2:kk-1
                    STA(k-1,1)=0;
                    STA(k-1,2)=0;
                    STA(k-1,3)=0;
                    STB(k-1)=0;
                end
                for k=2:kk-1
                    STA(k-1,1)=0;
                    STA(k-1,2)=0;
                    STA(k-1,3)=0;
                    STB(k-1)=0;
                end
                for k=2:kk-1
                    STA(k-1,1)=-(RHDZS+0.5*CLS1*Q(i,j,k)/DZ);
                    STA(k-1,2)=2*RHDZS;
                    STA(k-1,3)=-(RHDZS-0.5*CLS1*Q(i,j,k)/DZ);
                    STB(k-1)=CLS2*VIS(i,j,k)/HIJ*(DUDZ(i,j,k)^2+DVDZ(i,j,k)^2);
                    if UU(i,j,k)>=0
                        STA(k-1,2)=STA(k-1,2)+CLS1*DEN(i,j,k)*UU(i,j,k)/hx;
                        STB(k-1)=STB(k-1)+CLS1*DEN(i,j,k)*UU(i,j,k)*T(i-1,j,k)/hx;
                    else
                        STA(k-1,2)=STA(k-1,2)-CLS1*DEN(i,j,k)*UU(i,j,k)/hx;
                        STB(k-1)=STB(k-1)-CLS1*DEN(i,j,k)*UU(i,j,k)*T(i+1,j,k)/hx;
                    end
                    if j==1 || j==jj
                        if j==1
                            STA(k-1,2)=STA(k-1,2)-CLS1*RoL*DEN(i,j,k)*VV(i,j,k)/hy;
                            STB(k-1)=STB(k-1)-CLS1*RoL*DEN(i,j,k)*VV(i,j,k)*T(i,j+1,k)/hy;
                        else
                            STA(k-1,2)=STA(k-1,2)+CLS1*RoL*DEN(i,j,k)*VV(i,j,k)/hy;
                            STB(k-1)=STB(k-1)+CLS1*RoL*DEN(i,j,k)*VV(i,j,k)*T(i,j-1,k)/hy;
                        end
                    else
                        if VV(i,j,k)<0
                            STA(k-1,2)=STA(k-1,2)-CLS1*RoL*DEN(i,j,k)*VV(i,j,k)/hy;
                            STB(k-1)=STB(k-1)-CLS1*RoL*DEN(i,j,k)*VV(i,j,k)*T(i,j+1,k)/hy;
                        else
                            STA(k-1,2)=STA(k-1,2)+CLS1*RoL*DEN(i,j,k)*VV(i,j,k)/hy;
                            STB(k-1)=STB(k-1)+CLS1*RoL*DEN(i,j,k)*VV(i,j,k)*T(i,j-1,k)/hy;
                        end
                    end
                end
                STB(1)=STB(1)-STA(1,1)*T(i,j,1);
                STB(kk-2)=STB(kk-2)-STA(kk-2,3)*T(i,j,kk);
                %% 通过追赶法计算温度
                matrix_STA=zeros(kk-2,kk);
                matrix_STB=zeros(kk-2,1);
                for k=2:kk-1
                    start_pos=k-1;
                    end_pos=k+1;
                    matrix_STA(k-1,start_pos:end_pos)=STA(k-1,:);
                    matrix_STB(k-1)=STB(k-1);
                end
                matrix_STA(:,1)=[];
                matrix_STA(:,end)=[];
                TK=linsolve(matrix_STA,matrix_STB);
                %%
                for k=2:kk-1
                    if TK(k-1)<1
                        TK(k-1)=1;
                    end
                    T(i,j,k)=TK(k-1);
                end
            end
        end
    end
    
    %     for j=1:jj
    %         for k=2:kk-1
    %             T(1,j,k)=(T(1,j,k)+T(ii,j,k))/2.0;
    %         end
    %     end
    
    for i=1:ii
        for j=1:jj
            for k=2:kk-1
                ERRTA=ERRTA+abs(T(i,j,k)-TOLD(i,j,k));
                SUMTA=SUMTA+abs(T(i,j,k));
            end
        end
    end
    ERRTA=ERRTA/SUMTA
    for i=1:ii
        for j=1:jj
            for k=2:kk-1
                T(i,j,k)=OMIGT*TOLD(i,j,k)+OMIGT*T(i,j,k);
            end
        end
    end
    C2=ERRTA;
end
L{1,19}=T;
end