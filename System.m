function [X,V,A] = System(x,v,a,t,n)
X=zeros(1,n);
V=zeros(1,n);
A=zeros(1,n);
A=A+a;

X(1)=x;
V(1)=v;

for i=1:n-1
    X(i+1)=X(i)+V(i)*t+A(i)*t*t/2;
    V(i+1)=V(i)+A(i)*t;
end

end
