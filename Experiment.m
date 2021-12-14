%% Initialization
clear ; close all; clc
format ShortG ;

t_samp=5; %track-to-track interval
n=500; %Number of Samples
epsilon=0.1; %To check for convergence

t=linspace(t_samp,t_samp*n,n); %time values
%% ==================== Static System ====================
% true_val=1000;
% [X,~,~]=System(true_val,0,0,t_samp,n);
% Z = X+3*randn(1,n);
% 
% alpha=1:n;
% alpha=1./alpha;
% 
% val_guess=900;
% 
% [x,~,~,~,~,~]=Filter(alpha,0,0,t_samp,Z,val_guess,0,0);
% 
% %[t./t_samp;Z;x] %#ok<NOPTS> 
% figure
% plot(t,X,t,Z,t,x,'linewidth',1.5);
% legend("True Value","Measurements","Estimates");
% 
% E=abs(((X-x)./X)*100);
% figure
% plot(t,E,'linewidth',1.5);
% legend("Error Percentage");
% 
% disp(find(E>=epsilon,1,'last'));
% 
% fprintf('Program paused. Press enter to continue.\n');
% pause;
% close all;
% %% ======================= Constant Velocity =======================
% x_init=30000;
% v_init=40;
% [X,~,~]=System(x_init,v_init,0,t_samp,n);
% 
% Z = X+200*randn(1,n);
% 
% alpha=0.2;
% beta=0.1;
% 
% x_guess=35000;
% v_guess=60;
% %Filter(alpha,beta,gamma,t,z ,x_guess,v_guess,a_guess)
% [x,~,~,x_est,~,~]=Filter(alpha,beta,0,t_samp,Z,x_guess,v_guess,0);
% 
% %[t./t_samp;X;Z;x;v;x_est;v_est] %#ok<NOPTS> 
% figure
% plot(t,X,t,Z,t,x,t,x_est,'linewidth',1.5);
% %plot(t,X,'linewidth',1.5);
% 
% legend("True Value","Measurements","Estimates","Predictions");
% E=abs(((X-x)./X)*100);
% figure
% plot(t,E,'linewidth',1.5);
% legend("Error Percentage");
% 
% disp(find(E>epsilon,1,'last'));
% fprintf('Program paused. Press enter to continue.\n');
% pause;
% close all;
%% =================== Constant Acceleration ===================
x_init=30000;
v_init=40;
a_init=zeros(1,n);
n2=40;
a_init(n2:end)=80;

[X,V,A]=System(x_init,v_init,a_init,t_samp,n);

Z = X+10000*randn(1,n);

alpha=0.2;
beta=0.1;
gamma=0.01;

x_guess=60000;
v_guess=40;
a_guess=0;
%Filter(alpha,beta,gamma,t,z ,x_guess,v_guess,a_guess)
[x,v,a,x_est,v_est,a_est]=Filter(alpha,beta,gamma,t_samp,Z,x_guess,v_guess,a_guess);

%[t./t_samp;X;Z;x;v;x_est;v_est] %#ok<NOPTS> 
figure
plot(t,X,t,Z,t,x,t,x_est,'linewidth',1.5);
legend("True Value","Measurements","Estimates","Predictions");

figure
plot(t,V,t,v,t,v_est,'linewidth',1.5);
legend("True Value","Estimates","Predictions");

figure
plot(t,A,t,a,t,a_est,'linewidth',1.5);
legend("True Value","Estimates","Predictions");

E=abs(((X-x)./X)*100);
figure
plot(t,E,'linewidth',1.5);
legend("Error Percentage");

disp(find(E>epsilon,1,'last'));
fprintf('Program paused. Press enter to continue.\n');
pause;
close all;