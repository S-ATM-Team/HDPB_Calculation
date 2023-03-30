function QCAL()
%%  ‰»Î
global ii jj kk DZ RoL
global UU DEN VV h hx hy hx2 hy2
%%  ‰≥ˆ
global Q DEDU DEDV
%% º∆À„
for i=1:ii
    for j=1:jj
        for k=1:kk
            Q(i,j,k)=0;
            DEDU(i,j,k)=0;
            DEDV(i,j,k)=0;
        end
    end
end
for i=1:ii
    for j=1:jj
        for k=2:kk
            DEDU(i,j,k)=DEDU(i,j,k-1)+0.5*DZ*(DEN(i,j,k-1)*UU(i,j,k-1)+DEN(i,j,k)*UU(i,j,k));
            DEDV(i,j,k)=DEDV(i,j,k-1)+0.5*DZ*(DEN(i,j,k-1)*VV(i,j,k-1)+DEN(i,j,k)*VV(i,j,k));
        end
    end
end
for i=1:ii
    for j=1:jj
        for k=2:kk
            DEDU(i,j,k)=DEDU(i,j,k)*h(i,j);
            DEDV(i,j,k)=DEDV(i,j,k)*h(i,j)*RoL;
        end
    end
end
for k=2:kk
    for i=2:ii-1
        for j=2:jj-1
            Q(i,j,k)=(DEDU(i+1,j,k)-DEDU(i-1,j,k))/hx2+(DEDV(i,j+1,k)-DEDV(i,j-1,k))/hy2;
        end
    end
    i=1;
    for j=2:jj-1
        Q(i,j,k)=(DEDU(i+1,j,k)-DEDU(i,j,k))/hx+(DEDV(i,j+1,k)-DEDV(i,j-1,k))/hy2;
    end
    i=ii;
    for j=2:jj-1
        Q(i,j,k)=(DEDU(i,j,k)-DEDU(i-1,j,k))/hx+(DEDV(i,j+1,k)-DEDV(i,j-1,k))/hy2;
    end
    j=1;
    for i=2:ii-1
        Q(i,j,k)=(DEDU(i+1,j,k)-DEDU(i-1,j,k))/hx2+(DEDV(i,j+1,k)-DEDV(i,j,k))/hy;
    end
    j=jj;
    for i=2:ii-1
        Q(i,j,k)=(DEDU(i+1,j,k)-DEDU(i-1,j,k))/hx2+(DEDV(i,j,k)-DEDV(i,j-1,k))/hy;
    end
    
    i=1;
    j=1;
    Q(i,j,k)=(DEDU(i+1,j,k)-DEDU(i,j,k))/hx+(DEDV(i,j+1,k)-DEDV(i,j,k))/hy;
    i=1;
    j=jj;
    Q(i,j,k)=(DEDU(i+1,j,k)-DEDU(i,j,k))/hx+(DEDV(i,j,k)-DEDV(i,j-1,k))/hy;
    i=ii;
    j=jj;
    Q(i,j,k)=(DEDU(i,j,k)-DEDU(i-1,j,k))/hx+(DEDV(i,j,k)-DEDV(i,j-1,k))/hy;
    i=ii;
    j=1;
    Q(i,j,k)=(DEDU(i,j,k)-DEDU(i-1,j,k))/hx+(DEDV(i,j+1,k)-DEDV(i,j,k))/hy;
end
for i=1:ii
    for j=1:jj
        for k=1:kk
            Q(i,j,k)=-Q(i,j,k)/h(i,j);
        end
    end
end
end