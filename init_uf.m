function [U,L]=init_uf(U,L,global_para,level,epsilon)
%% 释放参数
bearing_num=global_para.split_para.bearing_num;
Length_point=global_para.split_para.Length_point;
% 释放结构参数
C0=global_para.structure_para.C0;
Length=global_para.structure_para.Length;
% 释放初始参数
titling1=global_para.initial_para.titling1;
titling2=global_para.initial_para.titling2;
% 释放变形参数
non_unit_deformation_oil_film=global_para.deform.non_unit_deformation_oil_film;
profile_point=global_para.profile_para.profile_point;
%%
% maxlevel=U.maxlevel;
for floor_num=1:bearing_num
    ii=L{floor_num}{level,3};
    jj=L{floor_num}{level,4};
    kk=L{floor_num}{level,5};
    single_non_unit_deformation_oil_film=non_unit_deformation_oil_film{floor_num};
    single_profile_point=profile_point{floor_num};
    start_point=2*floor_num-1;
    end_point=2*floor_num;
    yy=linspace(Length_point(start_point),Length_point(end_point),jj);
    for I=1:ii
        x=U.xa+(I-1)*L{floor_num}{level,1};
        for J=1:jj
            L{floor_num}{level,7}(I,J)=oil_film_thickness(x,epsilon,yy(J),single_non_unit_deformation_oil_film(I,J),single_profile_point(1,J),titling1,titling2,Length,C0);
            %%
            if L{floor_num}{level,7}(I,J)<0
                errordlg('油膜厚度小于0，请重新调整参数计算');
            end
            %%
            if ~(isreal(L{floor_num}{level,7}(I,J)))
                errordlg('油膜厚度出现复数，请重新调整修形参数');
            end
            %% 设置的原始温度
%             for K=1:kk
%                 L{floor_num}{level,19}(I,J,K)=1;
%             end
        end
    end
end
HH=L{floor_num}{level,7};
end