function [U,L,global_para]=bearing_property(U,L,global_para)
%% �����ͷ�
Rbearing=global_para.structure_para.Rbearing;     % ��λΪ mm
Rbearing=Rbearing*1E-3;                           % ��λΪ m
single_Length=global_para.split_para.bearing_single_Length;     % ��λΪ mm
single_Length=single_Length*1E-3;                  % ��λΪ m
bearing_num=global_para.split_para.bearing_num;

Pdim=global_para.middle_para.Pdim;
Um=global_para.middle_para.Um;                     % �ᾱת�� m/s
C0=global_para.structure_para.C0;
%%
if global_para.switch.DENVIS_switch==0 || global_para.switch.DENVIS_switch==3
    %% ���������¶� ���� �¶�Ϊ��ά�¶ȳ�����ʱ
    Vis=global_para.work_condition.Vis;     % �󻬽��ʵĹ�����
elseif global_para.switch.DENVIS_switch==2
    %% �����ñ�׼�����¶ȳ�ʱ
    Vis=L{1}{1,17}(1,1,1)*global_para.work_condition.Vis;             % ��߼��㶼��Ҫ�� ������󻬽��ʹ�����
elseif global_para.switch.DENVIS_switch==1
    %% �����þ��ȼ����¶ȳ�ʱ
    Vis=L{1}{1,17}(1,1,1)*global_para.work_condition.Vis;             % ��߼��㶼��Ҫ�� ������󻬽��ʹ�����
end
%%
% ��й����
single_Q_start=0;
single_Q_end=0;
Leakage=0;
% Ħ����
fri_force=0;
single_fri_force=0;
%
for floor_num=1:bearing_num
    ii=L{floor_num}{1,3};
    jj=L{floor_num}{1,4};
    nz=L{floor_num}{1,5};
    % ��Ҫ������а��Ǹ��ĵĵط�
    DX=L{floor_num}{1,1};
    dy=single_Length/(jj-1);
    unit_Vis=Vis*ones(ii,jj,nz);
    %% ��й�����ļ���
    non_unit_p=L{floor_num}{1,6};
    non_unit_h=L{floor_num}{1,7};
    unit_p=non_unit_p/Pdim;    % ��λΪ Pa
    unit_h=non_unit_h*C0/1E3;      % ��λΪ m
    if bearing_num==1
        for I=1:ii
            DPDY_start=(unit_p(I,2)-unit_p(I,1))/dy;
            DPDY_end=(unit_p(I,end-1)-unit_p(I,end))/dy;
            single_Q_start=single_Q_start+(-Rbearing/12)*unit_h(I,1)^3/unit_Vis(I,1,1)*DPDY_start*DX;   % ����0.29Ϊ�¶�Ӱ���֮����ȣ�Ҫ�ǵ��޸�
            single_Q_end=single_Q_end+(-Rbearing/12)*unit_h(I,end)^3/unit_Vis(I,end,1)*DPDY_end*DX;
        end
        Leakage=single_Q_start+single_Q_end;    % ��λΪ m^3/s
        Leakage=Leakage*60*1000;     % m^3/s ת��Ϊ L/min
    else
        if floor_num==1
            for I=1:ii
                DPDY_start=(unit_p(I,2)-unit_p(I,1))/dy;
                single_Q_start=single_Q_start+(-Rbearing/12)*unit_h(I,1)^3/unit_Vis(I,1,1)*DPDY_start*DX;   % ����0.29Ϊ�¶�Ӱ���֮����ȣ�Ҫ�ǵ��޸�
            end
            Leakage(1)=single_Q_start*60*1000;     % m^3/s ת��Ϊ L/min
        elseif floor_num==bearing_num
            for I=1:ii
                DPDY_end=(unit_p(I,end-1)-unit_p(I,end))/dy;
                single_Q_end=single_Q_end+(-Rbearing/12)*unit_h(I,end)^3/unit_Vis(I,end,1)*DPDY_end*DX;
            end
            Leakage(2)=single_Q_end*60*1000;     % m^3/s ת��Ϊ L/min
        end
    end
    %% Ħ�����ļ���
    for I=1:ii-1
        for J=1:jj
            DPDX=(unit_p(I+1,J)-unit_p(I,J))/(Rbearing*DX);
            fri_force=fri_force+(unit_Vis(I,J,1)*Um/unit_h(I,J)+unit_h(I,J)/2*DPDX)*dy*(DX*Rbearing);     % ����0.29Ϊ�¶�Ӱ���֮����ȣ�Ҫ�ǵ��޸�
        end
    end
end
%% ��й����
global_leakage=sum(Leakage);
%% Ħ��ϵ��
fri_coef=sum(fri_force)/(global_para.work_condition.Wkn*1E3);
%%
global_para.result.Leakage=abs(global_leakage);
global_para.result.fri_force=fri_force;
global_para.result.fri_coef=fri_coef;
end