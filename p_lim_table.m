function p_lim=p_lim_table(bearing_matrial)
if bearing_matrial==1
    %% Ǧ���Ͻ�������Ͻ�
    p_lim=15;
elseif bearing_matrial==2
    %% Cu-Pb�Ͻ�
    p_lim=20;
elseif bearing_matrial==3
    %% Cu-Sn�Ͻ�
    p_lim=25;
elseif bearing_matrial==4
    %% Al_Sn�Ͻ�
    p_lim=18;
elseif bearing_matrial==5
    %% Al_Zn�Ͻ�
    p_lim=20;
end