function Lup=Lu(U,p,h,rhx2,rhy2,I,J,ft,fz,fs,ht,DEVIE,DENS,RoL)
%%
hr=0.5*(DEVIE(I+1,J)*(h(I+1,J))^3*ft(I+1,J)+DEVIE(I,J)*(h(I,J))^3*ft(I,J));
hl=0.5*(DEVIE(I-1,J)*(h(I-1,J))^3*ft(I-1,J)+DEVIE(I,J)*(h(I,J))^3*ft(I,J));
hu=0.5*(DEVIE(I,J+1)*(h(I,J+1))^3*fz(I,J+1)+DEVIE(I,J)*(h(I,J))^3*fz(I,J));
hd=0.5*(DEVIE(I,J-1)*(h(I,J-1))^3*fz(I,J-1)+DEVIE(I,J)*(h(I,J))^3*fz(I,J)); 
Lup=rhx2*(hr*(p(I+1,J)-p(I,J))-hl*(p(I,J)-p(I-1,J)))...
    +RoL*RoL*rhy2*(hu*(p(I,J+1)-p(I,J))-hd*(p(I,J)-p(I,J-1)))...
    -0.5*sqrt(rhx2)*(ht(I+1,J)*DENS(I+1,J)-ht(I-1,J)*DENS(I-1,J))...
    -0.5*sqrt(rhx2)*(fs(I+1,J)*DENS(I+1,J)-fs(I-1,J)*DENS(I-1,J))*U.Rs;
end