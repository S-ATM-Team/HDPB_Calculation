function H=oil_film_thickness(x,epsilon,yy,deformation_oil_film,profile_point,final_titling1,final_titling2,Length,C0)
% 将弹性变形和修形考虑了进去
H=1+epsilon*cos(x)+(yy-Length/2)*tan(final_titling1)*cos(x-final_titling2)/C0+deformation_oil_film+profile_point/C0;
end