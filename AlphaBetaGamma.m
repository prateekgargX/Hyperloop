%clear;
%clc;

%alpha=0.5;
%beta=0.4;
%gamma=0.1;
t_samp=5; %track-to-track interval

%initialise values
x_init=30000;
v_init=40;
a_init=0;

z=load('abr.txt'); %measurements
n=size(z,2);
t=linspace(t_samp,t_samp*n,n); %time values

x=zeros(1,n); %range estimates of aircraft
v=zeros(1,n); %velocity estimates of aircraft
a=zeros(1,n); %acceleration estimates of aircraft


x_est=zeros(1,n); %range estimates of aircraft
v_est=zeros(1,n); %velocity estimates of aircraft
a_est=zeros(1,n); %acceleration estimates of aircraft

%Estimate initial values
x_temp=x_init+v_init*t_samp+a_init*t_samp*t_samp/2;
v_temp=v_init+a_init*t_samp;
a_temp=a_init;

for i = 1:n
    %Save temporary predicted estimates
    x_est(i)=x_temp;
    v_est(i)=v_temp;
    a_est(i)=a_temp;

    %State Extrapolation Equations:
        %x(i)=x_temp;
        %v(i)=v_temp;
        %a(i)=a_temp;

    %Present estimate after measurement
    x(i)=x_temp+alpha*(z(i)-x_temp);  
    v(i)=v_temp+beta*(z(i)-x_temp)/t_samp;
    a(i)=a_temp+2*gamma*(z(i)-x_temp)/t_samp/t_samp;
    x_temp=x(i)+v(i)*t_samp+a(i)*t_samp*t_samp/2;
    v_temp=v(i)+a(i)*t_samp;
    a_temp=a(i)
end

format shortG;
%format LONG E ;
[t./5;z;x;v;a;x_est;v_est;a_est] %#ok<NOPTS> 
figure
plot(t,x,t,z,t,x_est,'linewidth',1.5);
%figure
%plot(t,v,t,v_est);
figure
plot(t,a,t,a_est);
