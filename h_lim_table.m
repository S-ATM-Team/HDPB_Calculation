function h_lim =h_lim_table(Dbearing,RS)
%% 
U=RS*Dbearing;
if Dbearing>24 && 63>=Dbearing
    %%
    if 1>=U
        h_lim=3;
    elseif U>1 && 3>=U
        h_lim=4;
    elseif U>3 && 10>=U
        h_lim=5;
    elseif U>10 && 30>=U
        h_lim=7;
    elseif U>30
        h_lim=10;
    end
elseif Dbearing>63 && 160>=Dbearing
    %%
    if 1>=U
        h_lim=4;
    elseif U>1 && 3>=U
        h_lim=6;
    elseif U>3 && 10>=U
        h_lim=7;
    elseif U>10 && 30>=U
        h_lim=9;
    elseif U>30
        h_lim=12;
    end
elseif Dbearing>160 && 400>=Dbearing
    %%
    if 1>=U
        h_lim=6;
    elseif U>1 && 3>=U
        h_lim=7;
    elseif U>3 && 10>=U
        h_lim=9;
    elseif U>10 && 30>=U
        h_lim=11;
    elseif U>30
        h_lim=14;
    end
elseif Dbearing>400 && 1000>=Dbearing
    %%
    if 1>=U
        h_lim=8;
    elseif U>1 && 3>=U
        h_lim=9;
    elseif U>3 && 10>=U
        h_lim=11;
    elseif U>10 && 30>=U
        h_lim=13;
    elseif U>30
        h_lim=16;
    end
elseif Dbearing>1000 && 25000>=Dbearing
    %%
    if 1>=U
        h_lim=10;
    elseif U>1 && 3>=U
        h_lim=12;
    elseif U>3 && 10>=U
        h_lim=14;
    elseif U>10 && 30>=U
        h_lim=16;
    elseif U>30
        h_lim=18;
    end
end
h_lim=h_lim*1E-3;