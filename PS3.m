%% Initialization
%%We assume No systematic Bias. Values closest to the average are chosen
clear ; close all; clc

t_samp=5; %track-to-track interval
n=10; %Number of Samples
t=linspace(t_samp,t_samp*n,n); %time values

x_init=30000; %True initial range
v_init=40; %True velocity
[X,~,~]=System(x_init,v_init,0,t_samp,n);
%X,V are true states of the system
a  = 300; %Measurement uncertainity of sensors under normal operation
Z = X+sqrt(a)*randn(5,n);%Measurements of sensors stacked as matrix of dimension 5xNumber_of_samples

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
    
    %Update
    g = Z(:,i);
    avg_z=mean(g);
    Zb=zeros(1,0);
    for j = 1:3
        Zb=[Zb,g(abs(g-mean(g)) == min(abs(g-mean(g))));]
        g=g(abs(g-mean(g)) ~= min(abs(g-mean(g))));
    end
    x_est(i)=( ...
              x_pred(i)/px_pred(i)+ ...
              Zb(1,1)/a+ ...
              Zb(1,2)/a+ ...
              Zb(1,3)/a ...
              )/(1/px_pred(i)+3/a); %Estimating the current state, 
    px_est(i)=1/(1/px_pred(i)+3/a); %Update current state Uncertainity
    %This upadte equation is equivalent to stepwise update of sensor values
    
    %Predict
    x_temp=x_est(i)+v_guess*t_samp;
    %Extrapolated estimate uncertainty
    px_temp=px_est(i)+q;
end

%Visualizing the data
figure
plot(1:n,X,'g',1:n,x_est,'r-o',0,x_init,'y-d','LineWidth',1);
legend('True Value','Estimates','Initialization');
title('Range Estimates')
xlabel('Measurement Number')
ylabel('Range(m)')
pause;
close all;
