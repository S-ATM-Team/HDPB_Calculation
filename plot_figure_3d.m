R=160;
t=linspace(0,2*pi,101);
AttiAng=global_para.middle_para.AttiAng;
DX=2*pi/(101-1);
ele_num=floor(AttiAng/DX);
hhh=figure;
for floor_num=1:bearing_num
    Length_point=global_para.split_para.Length_point;
    start_ps=2*floor_num-1;
    end_ps=2*floor_num;
    h=linspace(Length_point(start_ps),Length_point(end_ps),41);%所画图形的z坐标范围
    z=zeros(length(h),length(t));
    for iI =1:length(h)
        z(iI,:)=h(iI);
    end
    x=zeros(length(h),length(t));
    y=zeros(length(h),length(t));
    for i =1:length(h)
        x(i,:)=cos(t);
    end
    for ii =1:length(h)
        y(ii,:)=sin(t);
    end
    x=x';
    y=-y';
    z=z';
    pp=L{floor_num}{1,6};
    former_pp=pp(101-ele_num:end,:);
    latter_pp=pp(1:101-ele_num-1,:);
    pp=[former_pp;latter_pp];
    mesh(z,x,y,pp,'facecolor','interp','facealpha',0.5);
    axis off
    hold on
end
colorbar
set(hhh,'color','w')
% contour3(z,x,y,pp)
% shading interp
% colormap(gray);