function global_para=bearing_profile_shaping(global_para,ny)
%% �ͷŲ���
profile_mode=global_para.profile_para.profile_mode;
Length=global_para.structure_para.Length;
Length_point=global_para.split_para.Length_point;
bearing_num=global_para.split_para.bearing_num;
%% ���η�ʽ
for I=1:bearing_num
    start_ps=2*I-1;
    end_ps=2*I;
    part_Length_mesh=linspace(Length_point(start_ps),Length_point(end_ps),ny);
    if profile_mode==0
        %% ������
        profile_point{I}=zeros(1,ny);
    elseif profile_mode==1
        %% ȫԲ������
        Rc=global_para.profile_para.Rc;
        half_Length=Length/2;
        if (Rc-(part_Length_mesh-half_Length))<0
            errordlg('ȫԲ�����Ρ�Rc��ֵ������')
        end
        profile_point{I}=Rc-sqrt(Rc^2-(part_Length_mesh-half_Length).^2);
    elseif profile_mode==2
        %% ����Բ������
        Rc=global_para.profile_para.Rc;
        small_l=global_para.profile_para.small_l;
        if small_l>Length
            errordlg('���γ������ô���');
        end
        half_l=small_l/2;
        half_Length=Length/2;
        y=part_Length_mesh-half_Length;
        for II=1:length(part_Length_mesh)
            single_y=y(II);
            if (Rc-(abs(single_y)-half_l))<0
                errordlg('����Բ�����Ρ�������ֵ������');
            end
            if abs(single_y)>half_l
                profile_point{I}(1,II)=Rc-sqrt(Rc^2-(abs(single_y)-half_l)^2);
            else
                profile_point{I}(1,II)=0;
            end
        end
    elseif profile_mode==3
        %% �ཻԲ������
        Rc=global_para.profile_para.Rc;
        small_l=global_para.profile_para.small_l;
        if small_l>Length
            errordlg('���γ������ô���');
        end
        half_l=small_l/2;
        half_Length=Length/2;
        y=part_Length_mesh-half_Length;
        for II=1:length(part_Length_mesh)
            single_y=y(II);
            if (Rc<half_l) && (Rc<single_y)
                errordlg('�ཻԲ�����Ρ�������ֵ������');
            end
            if abs(single_y)>half_l
                profile_point{I}(1,II)=sqrt(Rc^2-half_l^2)-sqrt(Rc^2-(single_y)^2);
            else
                profile_point{I}(1,II)=0;
            end
        end
    elseif profile_mode==4
        %% �û��Զ�������
        profile_other=global_para.profile_para.profile_other;
        point_num=length(profile_other);
        full_point=linspace(0,Length,point_num);
        profile_point{I}=interp1(full_point,profile_other,part_Length_mesh);
    end
end
global_para.profile_para.profile_point=profile_point;
end