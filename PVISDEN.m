function [U,L]=PVISDEN(U,L,k)
%%

ii=L{k,3};
jj=L{k,4};
kk=L{k,5};
DEVIE=L{k,15};
DENS=L{k,16};
VIS=L{k,17};
DEN=L{k,18};
VA=L{k,20};
VA0=L{k,21};
VA1=L{k,22};
DZ=1/(kk-1);

for I=1:ii
    for J=1:jj
        for K=1:kk
            VA(K)=1/VIS(I,J,K);
        end
        VA0(1)=0;
        VA1(1)=0;
        for KK=2:kk
            VA0(KK)=0;
            VA1(KK)=0;
            for KKK=1:KK-1
                VA0(KK)=VA0(KK)+0.5*DZ*(VA(KKK)+VA(KKK+1));
                VA1(KK)=VA1(KK)+0.5*DZ*(VA(KKK)*(KKK-1)*DZ+VA(KKK+1)*KKK*DZ);
            end
        end
        AIE=1/VA0(kk);
        AIE1=1/VA1(kk);
        
        DENS0=0;
        DENS1=0;
        DENS2=0;
        
        for K=1:kk-1
            DENS0=DENS0+0.5*DZ*(DEN(I,J,K)+DEN(I,J,K));
            DENS1=DENS1+0.5*DZ*(DEN(I,J,K)*VA0(K)+DEN(I,J,K)*VA0(K+1));
            DENS2=DENS2+0.5*DZ*(DEN(I,J,K)*VA1(K)+DEN(I,J,K)*VA1(K+1));
        end
        
        DEVIE(I,J)=12*(AIE*DENS1/AIE1-DENS2);
        DENS(I,J)=2*(DENS0-DENS1*AIE);
    end
end
%% 更新元胞数组L
L{I,21}=VA0;
L{I,22}=VA1;

L{k,15}=DEVIE;
L{k,16}=DENS;

end