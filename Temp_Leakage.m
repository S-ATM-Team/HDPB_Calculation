function flowrate=Temp_Leakage(global_para)
% �������Ϳ״����������Ϳ�λ��Ϊ Length/2
%%
global ii jj kk hy
global p h
global UU VV
%%
Leakage1=0;
Leakage2=0;
Length=global_para.split_para.bearing_single_Length*1E-3;    % ����λ mm ת��Ϊ m
%%
I=1;
flowrate=0;
for J=1:jj-1
    aveh=(h(I,J)+h(I,J+1))/2*global_para.structure_para.C0*1E-3;    % ����λ mm ת��Ϊ m
    
    aveu=0;
    
    for K=1:kk
        aveu=aveu+(UU(I,J,K)+UU(I,J+1,K));
    end
    aveu=aveu/(2*kk)*global_para.middle_para.Um;
    flowrate=flowrate+aveh*(hy*Length)/aveu;
end
flowrate=flowrate*1000*60;     % ��Ĥ��ʼ��Բ�ܷ�����洦������
end