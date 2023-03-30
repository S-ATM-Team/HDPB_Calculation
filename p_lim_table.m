function p_lim=p_lim_table(bearing_matrial)
if bearing_matrial==1
    %% 铅基合金和锡基合金
    p_lim=15;
elseif bearing_matrial==2
    %% Cu-Pb合金
    p_lim=20;
elseif bearing_matrial==3
    %% Cu-Sn合金
    p_lim=25;
elseif bearing_matrial==4
    %% Al_Sn合金
    p_lim=18;
elseif bearing_matrial==5
    %% Al_Zn合金
    p_lim=20;
end