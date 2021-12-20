%% Initialization
clear ; close all; clc
format ShortG ;

t_samp=5; %track-to-track interval
n=50; %Number of Samples
t=linspace(t_samp,t_samp*n,n); %time values

%% ======================= Scenario-I =======================
x_init=30000; %True initial range
v_init=40; %True velocity
[X,~,~]=System(x_init,v_init,0,t_samp,n);
%X,V are true states of the system
r1 = 200;%Measurement uncertainity of sensor-I
r2 = 300;%Measurement uncertainity of sensor-II
r3 = 400;%Measurement uncertainity of sensor-III
Z1 = X+sqrt(r1)*randn(1,n);%Measurements of sensor-I
Z2 = X+sqrt(r2)*randn(1,n);%Measurements of sensor-II
Z3 = X+sqrt(r3)*randn(1,n);%Measurements of sensor-III

x_guess=50000;%Initial Range Guess
v_guess=30;
px_guess=10000;%Initial uncertainity in Range Guess
q=0.15; %Process noise 

x_est=zeros(1,n); %range estimates
px_est=zeros(1,n); %estimates of uncertainity in estimates of range

x_pred=zeros(1,n); %predicted estimates range before measurement
px_pred=zeros(1,n); %predicted estimates of uncertainity in estimates before measurement

K=zeros(1,n); %Kalman gain

%Initial prediction values
x_temp=x_guess;
px_temp=px_guess;

%temp variables carries prediction from one iteration to next for
%ease of implementation. We save prediction for next state into temp variables
%and for the purposes of debugging and plotting save those values in
%the prediction arrays, we don't need them prediction arrays otherwise.

for i = 1:n
    %Save temporary predicted estimates
    x_pred(i)=x_temp;
    px_pred(i)=px_temp;

    %Measure Z1(i), Z2(i), Z3(i)
    %Update
    x_est(i)=(x_pred(i)/px_pred(i)+ ...
              Z1(i)/r1+ ...
              Z2(i)/r2+ ...
              Z3(i)/r3)/(1/px_pred(i)+1/r1+1/r2+1/r3); %Estimating the current state, 
    px_est(i)=1/(1/px_pred(i)+1/r1+1/r2+1/r3);             %Update current state Uncertainity
      %This upadte equation is equivalent to stepwise update of sensor values
    K(i)=1-px_est(i)/px_pred(i); %Kalman Gain
    %Predict
    x_temp=x_est(i)+v_guess*t_samp;
    %Extrapolated estimate uncertainty
    px_temp=px_est(i)+q;
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

pause;
close all;