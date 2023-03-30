function eta=vis_100(T)
EDA_s=[0.098,0.057,0.037,0.025];
T_s=[40,50,60,70];
eta=interp1(T_s,EDA_s,T);
end