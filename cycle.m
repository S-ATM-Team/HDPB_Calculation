function [U,L]=cycle(U,L,k,nu0,nu1,nu2,gamma)

if k==1
    for I=1:floor(nu0/2)
        [U,L]=relax(U,L,k);
    end
    relaxh0(U,L,k);
    for I=1:floor(nu0/2)
        [U,L]=relax(U,L,k);
    end
else
    for I=1:floor(nu1/2)
        [U,L]=relax(U,L,k);
    end
    relaxh0(U,L,k);
    for I=1:floor(nu1/2)
        [U,L]=relax(U,L,k);
    end
    [U,L]=coarsen_p(U,L,k);
    [U,L]=coarsen_f(U,L,k);
    for J=1:gamma
        [U,L]=cycle(U,L,k-1,nu0,nu1,nu2,gamma);
    end
    [U,L]=refine(U,L,k);
    for I=1:nu2
        [U,L]=relax(U,L,k);
    end
end

end