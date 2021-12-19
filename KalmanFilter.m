%clear;
%clc;
t_samp=5; %track-to-track interval
n=50;
%initialise values
x_true=30000;
v=40;

t=linspace(t_samp,t_samp*n,n); %time values
x_est=zeros(1,n); %range estimates
x_pred=zeros(1,n); %range predictions
z=zeros(1,n);%Measurements
p=zeros(1,n); %EStimate Uncertainity
k=zeros(1,n);%Kalman Gains
r=20*randn(1,n);

%Predict initial values
x_temp=x_true+v*t_samp;
v_temp=v;
p_temp=5; %Initial Estimate Uncertainity

for i = 1:n
    %Kalman Gain
    k(i)=p_temp/(p_temp+r(i));
    %Covariance Update
    p(i)=(1-k(i))*p_temp;
    %Save temporary predicted estimates
    x_pred(i)=x_temp;
    %Measurement
    z(i)=x_true+i*t_samp+r(i)
    %Present estimate after measurement( State Update)
    x_est(i)=x_pred(i)+k(i)*(z(i)-x_pred(i));  
    %State Extrapolation
    x_temp=x_est(i)+v(i)*t_samp;
    v_temp=v(i);
    %Covariance Extrapolation
    p_temp=p(i);
end

format shortG;
figure
plot(t,x_est,t,z,t,x_pred,'linewidth',1.5);
%figure
%plot(t,v,t,v_est);
figure
plot(t,a,t,a_est);
