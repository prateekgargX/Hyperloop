%True Value of hieght
H=50;
%initialise values
x_init=60;
p_init=225;

z=load('Building.txt'); %measurements
n=size(z,2); %Number of Samples provided in the file

x_est=zeros(1,n); %Height estimates of building
p_est=zeros(1,n); %estimates of uncertainity in estimates

x_pred=zeros(1,n); %predicted estimates height of building before measurement
p_pred=zeros(1,n); %predicted estimates of uncertainity in estimates before measurement

altimeter_uncertainity=25; %Measurement uncertainity
r=zeros(1,n)+altimeter_uncertainity; %Broadcasting to entire array
K=zeros(1,n); %Kalman gain

%Initial prediction values
x_temp=x_init;
p_temp=p_init;

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
    p_temp=p_est(i);                         %Extrapolated estimate uncertainty
end

%Visualizing the data
figure
plot(1:n,H*ones(1,n),'g',1:n,z,'b-s',1:n,x_est,'r-o',0,x_init,'y-d','LineWidth',1.5);
legend('True Value','Measurements','Estimates','Initialization');
title('Building Height')
xlabel('Measurement Number')
ylabel('Height(m)')
figure
plot(1:n,r,'b-s',1:n,p_est,'r-o',0,p_init,'y-d','LineWidth',1.5);
legend('Measurement Uncertainity','Estimate  Uncertainity','Initialization Uncertainity');
title('Uncertainities')
xlabel('Measurement Number')
ylabel('Uncertainity')
figure
plot(1:n,K,'k-v','LineWidth',1.5);
title('Kalman Gain')
xlabel('Measurement Number')
ylabel('Kalman Gain')
pause;
close all;