function PARTF()
%%  ‰»Î
global ii jj
global hx hy p 
%%  ‰≥ˆ
global DPDX DPDY
%% º∆À„
hx2=2*hx;
hy2=2*hy;
for j=2:jj-1
    for i=2:ii-1
        DPDX(i,j)=(p(i+1,j)-p(i-1,j))/hx2;
        DPDY(i,j)=(p(i,j+1)-p(i,j-1))/hy2;
    end
end
i=1;
for j=2:jj-1
    DPDX(i,j)=(p(i+1,j)-p(i,j))/hx;
    DPDY(i,j)=(p(i,j+1)-p(i,j-1))/hy2;
end
i=ii;
for j=2:jj-1
    DPDX(i,j)=(p(i,j)-p(i-1,j))/hx;
    DPDY(i,j)=(p(i,j+1)-p(i,j-1))/hy2;
end
j=1;
for i=2:ii-1
    DPDX(i,j)=(p(i+1,j)-p(i-1,j))/hx2;
    DPDY(i,j)=(p(i,j+1)-p(i,j))/hy;
end
j=jj;
for i=2:ii-1
    DPDX(i,j)=(p(i+1,j)-p(i-1,j))/hx2;
    DPDY(i,j)=(p(i,j)-p(i,j-1))/hy;
end
DPDX(1,1)=(p(2,1)-p(1,1))/hx;
DPDY(1,1)=(p(1,2)-p(1,1))/hy;

DPDX(ii,1)=(p(ii,1)-p(ii-1,1))/hx;
DPDY(ii,1)=(p(ii,2)-p(ii,1))/hy;

DPDX(1,jj)=(p(2,jj)-p(1,jj))/hx;
DPDY(1,jj)=(p(1,jj)-p(1,jj-1))/hy;

DPDX(ii,jj)=(p(ii,jj)-p(ii-1,jj))/hx;
DPDY(ii,jj)=(p(ii,jj)-p(ii,jj-1))/hy;
end