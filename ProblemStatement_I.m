%% Initialization
clear ; close all; clc
format ShortG ;

t_samp=5; %track-to-track interval
n=25; %Number of Samples
t=linspace(t_samp,t_samp*n,n); %time values

%% ======================= Scenario-I =======================
x_init=30000; %True initial range
v_init=40; %True velocity
[X,V,~]=System(x_init,v_init,0,t_samp,n);
%X,V are true states of the system
r1 = 200;%Measurement uncertainity of sensor-I
r2 = 300;%Measurement uncertainity of sensor-II
r3 = 400;%Measurement uncertainity of sensor-III
Z1 = X+sqrt(r1)*randn(1,n);%Measurements of sensor-I
Z2 = X+sqrt(r2)*randn(1,n);%Measurements of sensor-II
Z3 = X+sqrt(r3)*randn(1,n);%Measurements of sensor-III

x_guess=35000;%Initial Range Guess
v_guess=60;%Initial veocity guess
px_guess=1000;%Initial uncertainity in Range Guess
pv_guess=100;%Initial uncertainity in veocity guess

x_est=zeros(1,n); %range estimates
px_est=zeros(1,n); %estimates of uncertainity in estimates of range
v_est=zeros(1,n);%velocity estimates
pv_est=zeros(1,n);%estimates of uncertainity in estimates of velocity

x_pred=zeros(1,n); %predicted estimates range before measurement
px_pred=zeros(1,n); %predicted estimates of uncertainity in estimates before measurement
v_pred=zeros(1,n);%predicted estimates of velocity before measurement
pv_pred=zeros(1,n);%predicted estimates of uncertainity in estimates of velocity before measurement

K=zeros(1,n); %Kalman gain

%Initial prediction values
x_temp=x_guess;
px_temp=px_guess;
v_temp=v_guess;
pv_temp=pv_guess;
%temp variables carries prediction from one iteration to next for
%ease of implementation. We save prediction for next state into temp variables
%and for the purposes of debugging and plotting save those values in
%the prediction arrays, we don't need them prediction arrays otherwise.

for i = 1:n
    %Save temporary predicted estimates
    x_pred(i)=x_temp;
    px_pred(i)=px_temp;
    v_pred(i)=v_temp;
    pv_pred(i)=pv_temp;

    %Measure Z1(i), Z2(i), Z3(i)
    %Update1
    K(i) =px_pred(i)/(px_pred(i)+r1);          %Kalman Gain calculation,
    x_es =x_pred(i)+K(i)*(Z1(i)-x_pred(i)); %Estimating the current state, 
    px_es=(1-K(i))*px_pred(i);             %Update current state Uncertainity
    
    %Update2
    K(i)=px_es/(px_es+r2);          %Kalman Gain calculation,
    x_es=x_es+K(i)*(Z2(i)-x_es);%Estimating the current state, 
    px_es=(1-K(i))*px_es;             %Update current state Uncertainity
    
    %Update3
    K(i)=px_es/(px_es+r3);          %Kalman Gain calculation,
    x_est(i)=x_es+K(i)*(Z3(i)-x_es); %Estimating the current state, 
    px_est(i)=(1-K(i))*px_es;             %Update current state Uncertainity
    
    v_pred(i)= v_pred(i)+K(i)*(x_est(i)-x_pred(i))/t_samp;
    pv_pred(i)=(1-K(i))*pv_pred(i);
    %Predict
    x_temp=x_est(i)+t_samp*v_pred(i);
    v_temp=v_pred(i);
    %Extrapolated estimate uncertainty
    px_temp=px_est(i)+t_samp*t_samp*pv_pred(i);
    pv_temp=pv_pred(i);
end

%Visualizing the data
figure
plot(1:n,X,'g',1:n,Z1,'b--s',1:n,Z2,'b--s',1:n,Z3,'b--s',1:n,x_est,'r-o',0,x_init,'y-d','LineWidth',1.5);
legend('True Value','Measurement-I','Measurement-II','Measurement-III','Estimates','Initialization');
title('Range Estimates')
xlabel('Measurement Number')
ylabel('Range(m)')
figure
plot(1:n,px_est,'b-s',1:n,px_est,'r-o','LineWidth',1.5);
legend('Estimate  Uncertainity');
title('Uncertainity')
xlabel('Measurement Number')
ylabel('Uncertainity')
figure
plot(1:n,K,'k-v','LineWidth',1.5);
title('Kalman Gain')
xlabel('Measurement Number')
ylabel('Kalman Gain')

pause;
close all;