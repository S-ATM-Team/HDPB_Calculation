function global_para=bearing_split_para(global_para)
%% 释放参数
bearing_single_Length=global_para.split_para.bearing_single_Length;    % 单个轴承段的长度
bearing_num=global_para.split_para.bearing_num;                        % 轴承的个数
Length=global_para.structure_para.Length;                                 % 轴承的总长度
Rbearing=global_para.structure_para.Rbearing;                             % 轴承的半径
%% 计算得到每段轴承的长度及每段间隙的长度
gap_num=bearing_num-1;
if gap_num==0
    gap_Length=0;
else
    global_gap_Length=Length-bearing_num*bearing_single_Length;
    gap_Length=global_gap_Length/gap_num;
end
%% 组装 global_Length
global_Length=[];
for I=1:bearing_num
    if I==bearing_num
        global_Length=[global_Length,bearing_single_Length];
    else
        global_Length=[global_Length,bearing_single_Length,gap_Length];
    end
end
%% 计算每个节点的位置
part_num=length(global_Length);    % 轴承段数
for I=1:part_num+1
    if I==1
        Length_point(I)=0;
    elseif I==part_num+1
        Length_point(I)=Length;
    else
        Length_point(I)=Length_point(I-1)+global_Length(I-1); 
    end
end
%% 
for I=1:bearing_num
    II=2*I-1;
    LoR(I)=global_Length(II)/Rbearing;
    RoL(I)=Rbearing/global_Length(II);
    part_Length(I)=global_Length(II);
end
%%
global_para.split_para.part_num=part_num;
global_para.split_para.bearing_num=bearing_num;
global_para.split_para.Length_point=Length_point;
global_para.split_para.part_Length=part_Length;
global_para.split_para.LoR=LoR;
global_para.split_para.RoL=RoL;
end