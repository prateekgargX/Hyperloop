%% Initialization
clear ; close all; clc
format ShortG ;

t_samp=5; %track-to-track interval
n=500000; %Number of Samples
t=linspace(t_samp,t_samp*n,n); %time values
%% ==================== Static System ====================
true_val=1000;
[X,V,A]=System(true_val,0,0,t_samp,n);
Z = X+randn(1,n);

alpha=1:n;
alpha=1./alpha;

val_guess=998;

%Filter(alpha,beta,gamma,t,z ,x_guess,v_guess,a_guess)
[x,v,a,x_est,v_est,a_est]=Filter(alpha,0,0,t_samp,Z,val_guess,0,0);

[t./t_samp;Z;x] %#ok<NOPTS> 
figure
plot(t,X,t,Z,t,x,'linewidth',1.5);
legend("True Value","Measurements","Estimates");
fprintf('Program paused. Press enter to continue.\n');
pause;

%% ======================= Part 2: Plotting =======================

%% =================== Part 3: Cost and Gradient descent ===================
