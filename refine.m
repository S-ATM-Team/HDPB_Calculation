function [U,L]=refine(U,L,k)

ii=L{k,3};
jj=L{k,4};
p=L{k,6};

kc=k-1;
iic=L{kc,3};
jjc=L{kc,4};
pc=L{kc,6};
pco=L{kc,9};

for ic=2:iic
    for jc=2:jjc
        
        if ic<iic
            if p(2*ic-1,2*jc-1)>0
                p(2*ic-1,2*jc-1)=p(2*ic-1,2*jc-1)+(pc(ic,jc)-pco(ic,jc));
            end
        end
        
        if jc<jjc
            if p(2*ic-2,2*jc-1)>0
                p(2*ic-2,2*jc-1)=p(2*ic-2,2*jc-1)+(pc(ic,jc)-pco(ic,jc)+pc(ic-1,jc)-pco(ic-1,jc))*0.5;
            end
        end
        
        if ic<iic
            if p(2*ic-1,2*jc-2)>0
                p(2*ic-1,2*jc-2)=p(2*ic-1,2*jc-2)+(pc(ic,jc)-pco(ic,jc)+pc(ic,jc-1)-pco(ic,jc-1))*0.5;
            end
        end
        
        if p(2*ic-2,2*jc-2)>0
            p(2*ic-2,2*jc-2)=p(2*ic-2,2*jc-2)+(pc(ic,jc)-pco(ic,jc)+pc(ic,jc-1)-pco(ic,jc-1)+pc(ic-1,jc)-pco(ic-1,jc)+pc(ic-1,jc-1)-pco(ic-1,jc-1))*0.25;
        end
    end
end

for I=2:ii
    for J=2:jj
        if p(I,J)<0
            p(I,J)=0;
        end
    end
end
%% 更新元胞数组L
L{k,6}=p;

end