function Ares = soft_shrinkage(A,t)
[U,S,V]=svd(A);

r=size(S,1);
x=diag(S)-t;
x(x<0)=0;
ind=1:r+1:r*r;
ind=ind(1:numel(x));
S(ind)=x;
%{
S=S-t;
S(S<0)=0;
%}
Ares=U*S*V';
end

