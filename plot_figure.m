%% figure
h_fig=figure;
p_fig=figure;
Length_point=global_para.split_para.Length_point;
for floor_num=1:bearing_num
    ii=L{floor_num}{1,3};
    jj=L{floor_num}{1,4};
    start_ps=2*floor_num-1;
    end_ps=2*floor_num;
    line_x=linspace(0,360,ii);
    line_y=linspace(Length_point(start_ps),Length_point(end_ps),jj);
    [mesh_x,mesh_y]=meshgrid(line_x,line_y);
    mesh_x=mesh_x';
    mesh_y=mesh_y';
    %% 油膜厚度分布
    figure(h_fig)
    hold on
    h=L{floor_num}{1,7};
    mesh(mesh_x,mesh_y,h);
    %% 油膜压力分布
    figure(p_fig)
    hold on
    p=L{floor_num}{1,6};
    mesh(mesh_x,mesh_y,p);
end