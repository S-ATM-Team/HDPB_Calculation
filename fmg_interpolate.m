function [U,L]=fmg_interpolate(U,L,k)

ii=L{k,3};
jj=L{k,4};
p=L{k,6};

kc=k-1;
iic=L{kc,3};
jjc=L{kc,4};
pc=L{kc,6};
pconv=L{kc,10};

for ic=2:iic-1
    for jc=2:jjc-1
        pconv(ic,jc)=pc(ic,jc);
    end
end

for ic=2:iic-1
    for jc=2:jjc-1
        p(2*ic-1,2*jc-1)=pc(ic,jc);
    end
end

for I=3:2:ii-2
    p(I,2)=(5*p(I,1)+15*p(I,3)-5*p(I,5)+p(I,7))*0.0625;
    
    for J=4:2:jj-3
        p(I,J)=(-p(I,J-3)+9*p(I,J-1)+9*p(I,J+1)-p(I,J+3))*0.0625;
        
    end
    p(I,jj-1)=(5*p(I,jj)+15*p(I,jj-2)-5*p(I,jj-4)+p(I,jj-6))*0.0625;
end

for J=2:jj-1
    p(2,J)=(5*p(1,J)+15*p(3,J)-5*p(5,J)+p(7,J))*0.0625;
    
    for I=4:2:ii-3
        p(I,J)=(-p(I-3,J)+9*p(I-1,J)+9*p(I+1,J)-p(I+3,J))*0.0625;
    end
    
    p(ii-1,J)=(5*p(ii,J)+15*p(ii-2,J)-5*p(ii-4,J)+p(ii-6,J))*0.0625;
end
%% 更新元胞数组L
L{kc,6}=pc;
L{kc,10}=pconv;
L{k,6}=p;
end