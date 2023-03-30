function global_para=bearing_split(global_Length,global_para)
%%
Length=global_para.structure_para.Length;
Rbearing=global_para.structure_para.Rbearing;
%%
part_num=length(global_Length);    % 轴承段数
if rem(part_num,2)~=1
    errordlg('轴承段数不符合要求');
end
for I=1:part_num+1
    if I==1
        Length_point(I)=0;
    elseif I==part_num+1
        Length_point(I)=Length;
    else
        Length_point(I)=Length_point(I-1)+global_Length(I-1); 
    end
end
if Length_point(end)~=Length
    error('轴承长度出错');
end
bearing_num=ceil(part_num/2);
for I=1:bearing_num
    II=2*I-1;
    LoR(I)=global_Length(II)/Rbearing;
    RoL(I)=Rbearing/global_Length(II);
    part_Length(I)=global_Length(II);
end
% 
global_para.split_para.part_num=part_num;
global_para.split_para.bearing_num=bearing_num;
global_para.split_para.Length_point=Length_point;
global_para.split_para.part_Length=part_Length;
global_para.split_para.LoR=LoR;
global_para.split_para.RoL=RoL;
end