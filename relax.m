%% relax
function [U,L,global_para]=relax(U,L,k,global_para,floor_num)
%% 释放参数
part_Length=global_para.split_para.part_Length;
single_Length=part_Length(floor_num);
Rbearing=global_para.structure_para.Rbearing;

RoL=Rbearing/single_Length;
Pdim=global_para.middle_para.Pdim;
Wkn=global_para.work_condition.Wkn;

epsilon=global_para.initial_para.epsilon;
AttiAng=global_para.middle_para.AttiAng;
%%
% k为多重网格法的迭代层数
[U,L]=prerelax2(U,L,k,global_para,floor_num);
hx=L{k,1};
hy=L{k,2};
ii=L{k,3};
jj=L{k,4};
p=L{k,6};
h=L{k,7};
f=L{k,8};
ft=L{k,11};
fz=L{k,12};
fs=L{k,13};
ht=L{k,14};

rhx2=1/(hx^2);
rhy2=1/(hy^2);

[U,L]=TVISDEN(U,L,k,global_para);
[U,L]=PVISDEN(U,L,k);

DEVIE=L{k,15};
DENS=L{k,16};

for I=2:ii-1
    for J=2:jj-1
        hr=0.5*(DEVIE(I+1,J)*(h(I+1,J))^3*ft(I+1,J)+DEVIE(I,J)*(h(I,J))^3*ft(I,J));
        hl=0.5*(DEVIE(I-1,J)*(h(I-1,J))^3*ft(I-1,J)+DEVIE(I,J)*(h(I,J))^3*ft(I,J));
        hu=0.5*(DEVIE(I,J+1)*(h(I,J+1))^3*ft(I,J+1)+DEVIE(I,J)*(h(I,J))^3*ft(I,J));
        hd=0.5*(DEVIE(I,J-1)*(h(I,J-1))^3*ft(I,J-1)+DEVIE(I,J)*(h(I,J))^3*ft(I,J));
        
        Lup=Lu(U,p,h,rhx2,rhy2,I,J,ft,fz,fs,ht,DEVIE,DENS,RoL);
        
        p(I,J)=p(I,J)+(f(I,J)-Lup)/(-rhx2*(hr+hl)-RoL*RoL*rhy2*(hu+hd));
        
        if p(I,J)<0
            p(I,J)=0;
        end
    end
end
err=0;
for I=2:ii-1
    for J=2:jj-1
        if p(I,J)>0
            Lup=Lu(U,p,h,rhx2,rhy2,I,J,ft,fz,fs,ht,DEVIE,DENS,RoL);
            err=err+abs(f(I,J)-Lup);
        end
    end
end
% fprintf("\nLevel %d Res. err = %e Res. load = %e Eccentricity ratio = %6f Attitude angle = %6f", floor_num, err / ((ii - 2) * (jj - 2)), , epsilon, AttiAng * 360 / 2 / pi);
fprintf("\nLevel %d Res. err = %e Eccentricity ratio = %6f Attitude angle = %6f", floor_num, err / ((ii - 2) * (jj - 2)),epsilon, AttiAng * 360 / 2 / pi);

%% 更新元胞数组L
part_p_error=err / ((ii - 2) * (jj - 2));
global_para.result.part_p_error(floor_num)=part_p_error;
L{k,6}=p;
end
%%






%% prerelax2
function [U,L]=prerelax2(U,L,k,global_para,floor_num)
%% 释放参数
part_Length=global_para.split_para.part_Length;
single_Length=part_Length(floor_num);
Rbearing=global_para.structure_para.Rbearing;
RoL=Rbearing/single_Length;
%%
hx=L{k,1};
hy=L{k,2};
ii=L{k,3};
jj=L{k,4};
p=L{k,6};
h=L{k,7};
f=L{k,8};
ft=L{k,11};
fz=L{k,12};
fs=L{k,13};
ht=L{k,14};

rhx2=1/(hx)^2;
rhy2=1/(hy)^2;

[U,L]=TVISDEN(U,L,k,global_para);
[U,L]=PVISDEN(U,L,k);

DEVIE=L{k,15};
DENS=L{k,16};
for I=1:ii
%     x=U.xa+(I-1)*L{k,1};
    for J=1:jj
%         yy=Length/(jj-1)*(J-1);
        h(I,J)=L{k,7}(I,J);
        if 1>=U.gama
            ft(I,J)=1-U.RC*exp(-U.Rr*h(I,J)/U.Rs);
        else
            ft(I,J)=1+U.RC*(h(I,J)/U.Rs)^(-U.Rr);
        end
        if U.gama>=1
            fz(I,J)=1-U.RC*exp(-U.Rr*h(I,J)/U.Rs);
        else
            fz(I,J)=1+U.RC*(h(I,J)/U.Rs)^(-U.Rr);
        end
        if 5>=h(I,J)/U.Rs
            fs(I,J)=U.RA1*(h(I,J)/U.Rs)^U.Ra1*exp(-U.Ra2*h(I,J)/U.Rs+U.Ra3*(h(I,J)/U.Rs)^2);
        else
            fs(I,J)=U.RA2*exp(-0.25*h(I,J)/U.Rs);
        end
        fs(I,J)=(U.Rqs/U.Rs)^2*fs(I,J)-(U.Rqb/U.Rs)^2*fs(I,J);
        
        ht(I,J)=h(I,J)+U.Rs*exp(-(0.599+0.9936*(h(I,J)/U.Rs)^2+0.22*(h(I,J)/U.Rs)^3+0.04545*(h(I,J)/U.Rs)^4));
    end
end



for count=1:3
    for J=2:jj-1
        i0=2;
        while p(i0,J)>0 && i0<ii
            i0=i0+1;
        end
        i1=i0-3;
        if 1>=i1
            i1=2;
        end
        i2=i0+2;
        if i2>ii-1
            i2=ii-1;
        end
        for I=i1:i2
            hr=0.5*(DEVIE(I+1,J)*(h(I+1,J))^3*ft(I+1,J)+DEVIE(I,J)*(h(I,J))^3*ft(I,J));
            hl=0.5*(DEVIE(I-1,J)*(h(I-1,J))^3*ft(I-1,J)+DEVIE(I,J)*(h(I,J))^3*ft(I,J));
            hu=0.5*(DEVIE(I,J+1)*(h(I,J+1))^3*ft(I,J+1)+DEVIE(I,J)*(h(I,J))^3*ft(I,J));
            hd=0.5*(DEVIE(I,J-1)*(h(I,J-1))^3*ft(I,J-1)+DEVIE(I,J)*(h(I,J))^3*ft(I,J));
            
            Lup=Lu(U,p,h,rhx2,rhy2,I,J,ft,fz,fs,ht,DEVIE,DENS,Rbearing/single_Length);
            
            p(I,J)=p(I,J)+(f(I,J)-Lup)/(-rhx2*(hr+hl)-RoL*RoL*rhy2*(hu+hd));
            
            if p(I,J)<0
                p(I,J)=0;
            end
        end
    end
end
%% 更新元胞数组L
L{k,7}=h;
L{k,6}=p;
L{k,11}=ft;
L{k,12}=fz;
L{k,13}=fs;
L{k,14}=ht;
end
%%






%% Lu
