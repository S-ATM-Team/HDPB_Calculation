function average_gap=average_gap_table(Dbearing,RS)
U=RS*Dbearing;   % RS为r/s，Dbearing为m，所以U为m/s
if 100>=Dbearing
    if 1>=U
        average_gap=1.32;
    elseif U>1 && 3>=U
        average_gap=1.6;
    elseif U>3 && 10>=U
        average_gap=1.9;
    elseif U>10 && 30>=U
        average_gap=2.24;
    elseif U>30
        average_gap=2.24;
    end
elseif Dbearing>100 && 250>=Dbearing
    if 1>=U
        average_gap=1.12;
    elseif U>1 && 3>=U
        average_gap=1.32;
    elseif U>3 && 10>=U
        average_gap=1.6;
    elseif U>10 && 30>=U
        average_gap=1.9;
    elseif U>30
        average_gap=2.24;
    end
elseif Dbearing>250
    if 1>=U
        average_gap=1.12;
    elseif U>1 && 3>=U
        average_gap=1.12;
    elseif U>3 && 10>=U
        average_gap=1.32;
    elseif U>10 && 30>=U
        average_gap=1.6;
    elseif U>30
        average_gap=1.9;
    end
end