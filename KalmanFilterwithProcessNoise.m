%initialise values
x_init=10;
p_init=10000;
q=0.0;

true_val=load('trueprocnoiseliq.txt');%True values of temperature
z=load('procnoiseliq.txt'); %measurements
n=size(z,2); %Number of Samples provided in the file

x_est=zeros(1,n); %Height estimates of liquid Temperature
p_est=zeros(1,n); %estimates of uncertainity in estimates

x_pred=zeros(1,n); %predicted estimates liquid Temperature before measurement
p_pred=zeros(1,n); %predicted estimates of uncertainity in estimates before measurement

altimeter_uncertainity=0.01; %Measurement uncertainity
r=zeros(1,n)+altimeter_uncertainity; %Broadcasting to entire array
K=zeros(1,n); %Kalman gain

%Initial prediction  values
x_temp=x_init;
p_temp=p_init+q;

%x_temp and p_temp changes carries predicted from one iteration to next for
%ease of implementation. We save prediction for next state into x_temp and
%p_temp and for the purposes of debugging and plotting save those values in
%the prediction arrays, we don't need them otherwise.

for i = 1:n
    %Save temporary predicted estimates
    x_pred(i)=x_temp;
    p_pred(i)=p_temp;
    %Measure z(i)
    %Update
    K(i)=p_pred(i)/(p_pred(i)+r(i))          %Kalman Gain calculation,
    x_est(i)=x_pred(i)+K(i)*(z(i)-x_pred(i)) %Estimating the current state, 
    p_est(i)=(1-K(i))*p_pred(i)              %Update current state Uncertainity
    %Predict
    x_temp=x_est(i);                         %Constant Dynamics
    p_temp=p_est(i)+q;                         %Extrapolated estimate uncertainty
end

%Visualizing the data
figure
plot(1:n,true_val,'g',1:n,z,'b-s',1:n,x_est,'r-o','LineWidth',1.5);
legend('True Value','Measurements','Estimates');
title('the liquid Temperature')
xlabel('Measurement Number')
ylabel('liquid Temperature(^{o}C)')
figure
plot(1:n,p_est,'r-o','LineWidth',1.5);
legend('Estimate Uncertainity');
title('Estimate Uncertainity')
xlabel('Measurement Number')
ylabel('Estimate Uncertainity')
figure
plot(1:n,K,'k-v','LineWidth',1.5);
title('Kalman Gain')
xlabel('Measurement Number')
ylabel('Kalman Gain')
pause;
close all;