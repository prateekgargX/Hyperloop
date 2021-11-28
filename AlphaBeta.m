clear;
clc;

alpha=0.2;
beta=0.1;
t_samp=5; %track-to-track interval

%initialise values
x_init=30000;
v_init=40;

z=load('ab.txt'); %measurements
n=size(z,2);
t=linspace(t_samp,t_samp*n,n); %time values

x=zeros(1,n); %range estimates of aircraft
v=zeros(1,n); %velocity estimates of aircraft

x_est=zeros(1,n); %range estimates of aircraft
v_est=zeros(1,n); %velocity estimates of aircraft

%Estimate initial values
x_temp=x_init+v_init*t_samp;
v_temp=v_init;
for i = 1:n
    %Save temporary predicted estimates
    x_est(i)=x_temp;
    v_est(i)=v_temp;


    %State Extrapolation Equations:
        %x(i)=x_temp;
        %v(i)=v_temp;
    
    %Present estimate after measurement
    x(i)=x_temp+alpha*(z(i)-x_temp);  
    v(i)=v_temp+beta*(z(i)-x_temp)/t_samp;
    
    x_temp=x(i)+v(i)*t_samp;
    v_temp=v(i);
    
end

format shortG;
%format LONG E ;
[t./5;z;x;v;x_est;v_est] %#ok<NOPTS> 
figure
plot(t,x,t,z,t,x_init+v_init*t,t,x_est, 'linewidth',1.5);
legend;
%figure
%plot(t,v,t,v_est, 'linewidth',1.5);
%legend;
