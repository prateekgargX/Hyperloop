%% Initialization
clear ; close all; clc
format ShortG ;

t_samp=5; %track-to-track interval
n=50; %Number of Samples
t=linspace(t_samp,t_samp*n,n); %time values

%% ======================= Scenario-II =======================
x_init=30000; %True initial range
v_init=40; %True velocity
[X,~,~]=System(x_init,v_init,0,t_samp,n);
%X,V are true states of the system
r2 = 300;%Measurement uncertainity of sensor-II
Z2 = X+sqrt(r2)*randn(1,n);%Measurements of sensor-II
x_guess=40000;%Initial Range Guess
v_guess=30;
px_guess=10000;%Initial uncertainity in Range Guess
q=0.15; %Process noise 

x_est=zeros(1,n); %range estimates
px_est=zeros(1,n); %estimates of uncertainity in estimates of range

x_pred=zeros(1,n); %predicted estimates range before measurement
px_pred=zeros(1,n); %predicted estimates of uncertainity in estimates before measurement

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

    %Measure Z2(i)
    %Update
    x_est(i)=(x_pred(i)/px_pred(i)+Z2(i)/r2)/(1/px_pred(i)+1/r2);  %Estimating the current state, 
    px_est(i)=1/(1/px_pred(i)+1/r2); %Update current state Uncertainity
    
    %Predict
    x_temp=x_est(i)+v_guess*t_samp;
    %Extrapolated estimate uncertainty
    px_temp=px_est(i)+q;
end

%Visualizing the data
figure
plot(1:n,X,'g',1:n,Z2,'b--s',1:n,x_est,'r-o',0,x_init,'y-d','LineWidth',1.5);
legend('True Value','Measurement-II','Estimates','Initialization');
title('Range Estimates')
xlabel('Measurement Number')
ylabel('Range(m)')
pause;

plot(1:n,px_est,'b-s',1:n,px_est,'r-o','LineWidth',1.5);
legend('Estimate  Uncertainity');
title('Uncertainity')
xlabel('Measurement Number')
ylabel('Uncertainity')
pause;
close all;