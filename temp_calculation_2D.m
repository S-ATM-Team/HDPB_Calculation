function [U,L,global_para]=temp_calculation_2D(U,L,global_para)
%%
AJ=4.184;    % 热功当量
%% 参数释放和部分参数计算
ii=L{1,3};
jj=L{1,4};
T=L{1,19};
p=L{1,6};
Vis0=global_para.work_condition.Vis;
Den0=global_para.work_condition.DEN0;
C0=global_para.structure_para.C0/1000;
Rbearing=global_para.structure_para.Rbearing/1000;
RS=global_para.work_condition.RS;
UU=RS*Rbearing*2*pi/60;
CF0=global_para.temp_calculation.CFO;
A=UU*Rbearing*Vis0/(2*AJ*Den0*CF0*C0^2);
T0=U.T0+273;
UT=T0/A;
Pdim=global_para.middle_para.Pdim;
P0=1/Pdim;
%% 温度计算参数初始化
err_temp=1;
while err_temp>1E-8
    err_temp=0;
    for i=2:ii
        for j=1:jj
            TOLD=T(i,j);
            A1=log(Vis0)+9.67;
            A2=(((A*UT-138)/(T0-138))^(-1.1))*((1+5.1E-9*P0*p(i,j))^0.5714)-1;
            VIS(i,j)=exp(A1*A2);
            
            if (i~=U.ii)
                DPDX=0.5*(p(i+1,j)-p(i-1,j))/hx;
            else
                DPDX=(p(i,j)-p(i-1,j))/hx;
            end
            
            QX=0.5*h(i,j)-0.5*h(i,j)^3/VIS(i,j)*DPDX;
            DPDY=ALFA1*(p(i,j+1)-p(i,j))/hy;
            
            QY=-0.5*h(i,j)^3/VIS(i,j)*DPDY;
            
            AA=QX/hx*T(i-1,j)-U.ALFA1^2*QY*T(i,j+1)/U.hy;
            AB=2*VIS(i,j)/h(i,j);
            
            AC=6*h(i,j)^3/VIS(i,j)*(DPDX^2+DPDY^2);
            
            BB=QX/hx-ALFA1^2*QY/hy;
            
            T(i,j)=(AA+AB+AC)/BB;
            
            if (A*T(i,j)>403)
                disp('T is over the limit 100');
            end
            
            T(i,j)=0.7*TOLD+0.3*T(i,j);
            
            err_temp=err_temp+abs(T(i,j)-TOLD)/303;
        end
    end
    
    err_temp=A*err_temp/((ii-1)*(jj-1));
    
end
disp('Temperature calculation ends');