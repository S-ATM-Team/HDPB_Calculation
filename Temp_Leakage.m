function flowrate=Temp_Leakage(global_para)
% 计算在油孔处的流量，油孔位置为 Length/2
%%
global ii jj kk hy
global p h
global UU VV
%%
Leakage1=0;
Leakage2=0;
Length=global_para.split_para.bearing_single_Length*1E-3;    % 将单位 mm 转化为 m
%%
I=1;
flowrate=0;
for J=1:jj-1
    aveh=(h(I,J)+h(I,J+1))/2*global_para.structure_para.C0*1E-3;    % 将单位 mm 转化为 m
    
    aveu=0;
    
    for K=1:kk
        aveu=aveu+(UU(I,J,K)+UU(I,J+1,K));
    end
    aveu=aveu/(2*kk)*global_para.middle_para.Um;
    flowrate=flowrate+aveh*(hy*Length)/aveu;
end
flowrate=flowrate*1000*60;     % 油膜起始处圆周方向截面处的流量
end