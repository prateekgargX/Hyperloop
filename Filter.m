function [x,v,a,x_est,v_est,a_est] = Filter(alph,bet,gamm,t,z ,x_guess,v_guess,a_guess)
n=size(z,2);

alpha=zeros(1,n);
beta=zeros(1,n);
gamma=zeros(1,n);

alpha=alpha+alph;
beta=beta+bet;
gamma=gamma+gamm;

x=zeros(1,n); %range estimates of aircraft post measurement
v=zeros(1,n); %velocity estimates of aircraft post measurement
a=zeros(1,n); %acceleration estimates of aircraft post measurement

x_est=zeros(1,n); %range estimates of aircraft before measurement
v_est=zeros(1,n); %velocity estimates of aircraft before measurement
a_est=zeros(1,n); %acceleration estimates of aircraft before measurement

t_samp=t;
%Estimate initial values
x_temp=x_guess+v_guess*t_samp+a_guess*t_samp*t_samp/2;
v_temp=v_guess+a_guess*t_samp;
a_temp=a_guess;

for i = 1:n
    %State Extrapolation Equations:
    x_est(i)=x_temp;
    v_est(i)=v_temp;
    a_est(i)=a_temp;

    %Present estimate after measurement
    x(i)=x_temp+alpha(i)*(z(i)-x_temp);  
    v(i)=v_temp+beta(i)*(z(i)-x_temp)/t_samp;
    a(i)=a_temp+2*gamma(i)*(z(i)-x_temp)/t_samp/t_samp;
    
    x_temp=x(i)+v(i)*t_samp+a(i)*t_samp*t_samp/2;
    v_temp=v(i)+a(i)*t_samp;
    a_temp=a(i);
end

end
