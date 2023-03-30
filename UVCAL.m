function UVCAL()
%%  ‰»Î
global ii jj kk RoL
global h DZ VIS 
global DPDX DPDY
%%  ‰≥ˆ
global UU VV DUDZ DVDZ
%% º∆À„
VE1=zeros(kk,1);
VE=zeros(kk,1);
for i=1:ii
    for j=1:jj
        HS2=6*h(i,j)^2;
        VE1(1)=0;
        VE(1)=0;
        for k=2:kk
            VE1(k)=VE1(k-1)+0.5*DZ*((k - 1) * DZ / VIS(i,j,k-1) + k * DZ / VIS(i,j,k));
            VE(k)=VE(k-1)+0.5*DZ*(1/VIS(i,j,k-1)+1/VIS(i,j,k));
        end
        VISE=1/VE(kk);
        VISE1=1/VE1(kk);
        VIE=VISE/VISE1;
        for k=1:kk
            UU(i,j,k)=HS2*(VE1(k)-VIE*VE(k))*DPDX(i,j)+VE(k)*VISE;
            VV(i,j,k)=HS2*(VE1(k)-VIE*VE(k))*DPDY(i,j)*RoL;
            
            DUDZ(i,j,k)=(HS2*(k*DZ-VIE)*DPDX(i,j)+VISE)/VIS(i,j,k);
            DVDZ(i,j,k)=HS2*(k*DZ-VIE)*DPDY(i,j)/VIS(i,j,k)*RoL;
        end
    end
end
end