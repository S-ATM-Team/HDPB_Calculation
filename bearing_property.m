function [U,L,global_para]=bearing_property(U,L,global_para)
%% 参数释放
Rbearing=global_para.structure_para.Rbearing;     % 单位为 mm
Rbearing=Rbearing*1E-3;                           % 单位为 m
single_Length=global_para.split_para.bearing_single_Length;     % 单位为 mm
single_Length=single_Length*1E-3;                  % 单位为 m
bearing_num=global_para.split_para.bearing_num;

Pdim=global_para.middle_para.Pdim;
Um=global_para.middle_para.Um;                     % 轴颈转速 m/s
C0=global_para.structure_para.C0;
%%
if global_para.switch.DENVIS_switch==0 || global_para.switch.DENVIS_switch==3
    %% 当不考虑温度 或者 温度为三维温度场计算时
    Vis=global_para.work_condition.Vis;     % 润滑介质的工作黏度
elseif global_para.switch.DENVIS_switch==2
    %% 当采用标准计算温度场时
    Vis=L{1}{1,17}(1,1,1)*global_para.work_condition.Vis;             % 后边计算都需要用 计算的润滑介质工作黏度
elseif global_para.switch.DENVIS_switch==1
    %% 当采用绝热计算温度场时
    Vis=L{1}{1,17}(1,1,1)*global_para.work_condition.Vis;             % 后边计算都需要用 计算的润滑介质工作黏度
end
%%
% 端泄流量
single_Q_start=0;
single_Q_end=0;
Leakage=0;
% 摩擦力
fri_force=0;
single_fri_force=0;
%
for floor_num=1:bearing_num
    ii=L{floor_num}{1,3};
    jj=L{floor_num}{1,4};
    nz=L{floor_num}{1,5};
    % 需要根据轴承包角更改的地方
    DX=L{floor_num}{1,1};
    dy=single_Length/(jj-1);
    unit_Vis=Vis*ones(ii,jj,nz);
    %% 端泄流量的计算
    non_unit_p=L{floor_num}{1,6};
    non_unit_h=L{floor_num}{1,7};
    unit_p=non_unit_p/Pdim;    % 单位为 Pa
    unit_h=non_unit_h*C0/1E3;      % 单位为 m
    if bearing_num==1
        for I=1:ii
            DPDY_start=(unit_p(I,2)-unit_p(I,1))/dy;
            DPDY_end=(unit_p(I,end-1)-unit_p(I,end))/dy;
            single_Q_start=single_Q_start+(-Rbearing/12)*unit_h(I,1)^3/unit_Vis(I,1,1)*DPDY_start*DX;   % 其中0.29为温度影响过之后的黏度，要记得修改
            single_Q_end=single_Q_end+(-Rbearing/12)*unit_h(I,end)^3/unit_Vis(I,end,1)*DPDY_end*DX;
        end
        Leakage=single_Q_start+single_Q_end;    % 单位为 m^3/s
        Leakage=Leakage*60*1000;     % m^3/s 转化为 L/min
    else
        if floor_num==1
            for I=1:ii
                DPDY_start=(unit_p(I,2)-unit_p(I,1))/dy;
                single_Q_start=single_Q_start+(-Rbearing/12)*unit_h(I,1)^3/unit_Vis(I,1,1)*DPDY_start*DX;   % 其中0.29为温度影响过之后的黏度，要记得修改
            end
            Leakage(1)=single_Q_start*60*1000;     % m^3/s 转化为 L/min
        elseif floor_num==bearing_num
            for I=1:ii
                DPDY_end=(unit_p(I,end-1)-unit_p(I,end))/dy;
                single_Q_end=single_Q_end+(-Rbearing/12)*unit_h(I,end)^3/unit_Vis(I,end,1)*DPDY_end*DX;
            end
            Leakage(2)=single_Q_end*60*1000;     % m^3/s 转化为 L/min
        end
    end
    %% 摩擦力的计算
    for I=1:ii-1
        for J=1:jj
            DPDX=(unit_p(I+1,J)-unit_p(I,J))/(Rbearing*DX);
            fri_force=fri_force+(unit_Vis(I,J,1)*Um/unit_h(I,J)+unit_h(I,J)/2*DPDX)*dy*(DX*Rbearing);     % 其中0.29为温度影响过之后的黏度，要记得修改
        end
    end
end
%% 端泄流量
global_leakage=sum(Leakage);
%% 摩擦系数
fri_coef=sum(fri_force)/(global_para.work_condition.Wkn*1E3);
%%
global_para.result.Leakage=abs(global_leakage);
global_para.result.fri_force=fri_force;
global_para.result.fri_coef=fri_coef;
end