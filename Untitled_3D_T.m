TT=T*(global_para.temp_calculation.T_envir+273.15)-273.15;
TTA=TT(:,:,6);
TTB=TTA(:,21);
plot(TTB)

load TTB08.mat
load TTB04.mat
load TTB06.mat
load TTB1.mat
plot(TTB)
hold on 
plot(TTB04)
plot(TTB08)
legend(['U=1'],['U=0.4'],['U=0.8'])