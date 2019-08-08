function Q = fixed_pt_iter(P, sig, eps, t, mu, max_iter)
%% sig - set of indices
%  
Qp=zeros(size(P));
rem=eps+1;
itr = 1;
while(rem>=eps && itr <= max_iter)
    R=Qp-t*sig.*(Qp-P);
    Q=soft_shrinkage(R,t*mu);
    rem=norm(Q-Qp, 'fro');
    Qp=Q;
    %disp([num2str(itr),' ',num2str(rem)]);
    itr = itr+1;
end

end

