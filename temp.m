function [U,L,global_para]=temp(U,L,global_para)
%%
heat_mode=global_para.switch.DENVIS_switch;
bearing_num=global_para.split_para.bearing_num;
%%
if heat_mode==2
    %% ���ñ�׼����ʱ�������ֵ��׷��˼��Σ�����������м����
    [U,L,global_para]=standard_temp_calculation(U,L,global_para);
elseif heat_mode==1
    %     global_para.result.Vis=global_para.work_condition.Vis;
    %% ���ù�ʽ���ձ�׼���о��ȼ���(�������ֵ��׷��˼��Σ�����������м����)
    [U,L,global_para]=temp_2D_simple(U,L,global_para);
elseif heat_mode==3
    %% ��ά���ȼ���
    bearing_num=global_para.split_para.bearing_num;
    for floor_num=1:bearing_num
        [U,L{floor_num},global_para]=temp_calculation_3D(U,L{floor_num},global_para);
    end
end
end