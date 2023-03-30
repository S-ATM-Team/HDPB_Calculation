function [U,L]=initialize(nx0,ny0,nz,maxlevel,gama,Rqb,Rqs,CRbRs,DENVIS_switch,T0,global_para)
%%
global bearing_nz shaft_nz
%%
U.xa=(2*pi-global_para.work_condition.bearing_angle)/2-global_para.middle_para.AttiAng;

U.xb=U.xa+global_para.work_condition.bearing_angle;
U.ya=0;
U.yb=1;
U.maxlevel=maxlevel;
U.wu=0;
U.gama=gama;
U.Rqb=Rqb/1E6/CRbRs;       % 该处 Rqb和Rqs单位均为 um，CRbRs单位为m
U.Rqs=Rqs/1E6/CRbRs;
U.Rs=sqrt(U.Rqb^2+U.Rqs^2);
U.T0=T0;      % 初始温度

hx=(U.xb-U.xa)/(nx0-1);
hy=(U.yb-U.ya)/(ny0-1);
ii=nx0;
jj=ny0;
L=cell(maxlevel,22);
%%   使用元胞数组组成初始矩阵
for I=1:maxlevel
    L{I,1}=hx;
    L{I,2}=hy;
    L{I,3}=ii;
    L{I,4}=jj;
    L{I,5}=nz;
    L{I,6}=zeros(ii,jj);          % p
    L{I,7}=zeros(ii,jj);          % h
    L{I,8}=zeros(ii,jj);          % f
    L{I,9}=zeros(ii,jj);          % pold
    L{I,10}=zeros(ii,jj);          % pconv
    L{I,11}=zeros(ii,jj);          % ft
    L{I,12}=zeros(ii,jj);          % fz
    L{I,13}=zeros(ii,jj);          % fs
    L{I,14}=zeros(ii,jj);          % ht
    L{I,15}=zeros(ii,jj);          % DEVIE
    L{I,16}=zeros(ii,jj);          % DENS
    L{I,17}=zeros(ii,jj,nz);         % VIS
    L{I,18}=zeros(ii,jj,nz);         % DEN
    if DENVIS_switch==1
        %% 二维绝热计算
        L{I,19}=ones(ii,jj);          % T
    elseif DENVIS_switch==3
        %% 三维绝热计算
        L{I,19}=ones(ii,jj,nz);
    elseif DENVIS_switch==2
        %% 按照标准计算轴承温度
        L{I,19}=ones(ii,jj,nz);
    end
    L{I,20}=zeros(nz,1);          % VA
    L{I,21}=zeros(nz,1);          % VA0
    L{I,22}=zeros(nz,1);          % VA1
    
    hx=0.5*hx;
    hy=0.5*hy;
    ii=(ii-1)*2+1;
    jj=(jj-1)*2+1;
    
    fprintf('\n Level = %d nx = %6d hx = %6f ny = %6d hy = %6f \n', I, ii, hx, jj, hy);
end
%%
if gama==1/9
    U.RC=1.48;
    U.Rr=0.42;
    U.RA1=2.046;
    U.Ra1=1.12;
    U.Ra2=0.78;
    U.Ra3=0.03;
    U.RA2=1.856;
elseif gama==1/6
    U.RC=1.38;
    U.Rr=0.42;
    U.RA1=1.962;
    U.Ra1=1.08;
    U.Ra2=0.77;
    U.Ra3=0.03;
    U.RA2=1.754;
elseif gama==1/3
    U.RC=1.18;
    U.Rr=0.42;
    U.RA1=1.858;
    U.Ra1=1.01;
    U.Ra2=0.76;
    U.Ra3=0.03;
    U.RA2=1.561;
elseif gama==1
    U.RC=0.9;
    U.Rr=0.56;
    U.RA1=1.899;
    U.Ra1=0.98;
    U.Ra2=0.92;
    U.Ra3=0.05;
    U.RA2=1.126;
elseif gama==3
    U.RC=0.225;
    U.Rr=1.5;
    U.RA1=1.56;
    U.Ra1=0.85;
    U.Ra2=1.13;
    U.Ra3=0.08;
    U.RA2=0.556;
elseif gama==6
    U.RC=0.52;
    U.Rr=1.5;
    U.RA1=1.29;
    U.Ra1=0.62;
    U.Ra2=1.09;
    U.Ra3=0.08;
    U.RA2=0.388;
elseif gama==9
    U.RC=0.87;
    U.Rr=1.5;
    U.RA1=1.011;
    U.Ra1=0.54;
    U.Ra2=1.07;
    U.Ra3=0.08;
    U.RA2=0.295;
else
    U.RC=0;
    U.Rr=0;
    U.RA1=0;
    U.Ra1=0.54;
    U.Ra2=1.07;
    U.Ra3=0.08;
    U.RA2=0;
end
end
