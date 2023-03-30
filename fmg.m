function [U,L,global_para]=fmg(U,L,k,nu0,nu1,nu2,gamma,ncy,global_para)
%% ÊÍ·Å²ÎÊý
bearing_num=global_para.split_para.bearing_num;
%%
if U.maxlevel==1
    for floor_num=1:bearing_num
%         for J=1:ncy-1
            for I=1:15
                [U,L{floor_num},global_para]=relax(U,L{floor_num},k,global_para,floor_num);
            end
%         end
    end
    [U,L,global_para]=relaxh0(U,L,k,global_para);
end

% if k==1
%     for I=1:floor(nu0/2)
%         [U,L]=relax(U,L,k,global_para);
%     end
%     relaxh0(U,L,k);
%     for I=1:floor(nu0/2)
%         [U,L]=relax(U,L,k,global_para);
%     end
%     relaxh0(U,L,k,global_para);
% else
%     [U,L]=fmg(U,L,k-1,nu0,nu1,nu2,gamma,ncy,global_para);
%     [U,L]=fmg_interpolate(U,L,k,global_para);
%     for J=1:ncy
%         [U,L]=cycle(U,L,k,nu0,nu1,nu2,gamma);
%     end
% end

end
