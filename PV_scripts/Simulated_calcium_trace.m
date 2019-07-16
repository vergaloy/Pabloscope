function [Y]=Simulated_calcium_trace(firerate);

g = [1.7, -0.712];         % AR coefficient 
noise = 0.5; 
T = 5400;      
framerate=10;
b = 0;              % baseline 
N = 1;              % number of trials 
seed = 'shuffle';          % seed for genrating random variables 
[Y, trueC, trueS] = gen_data(g, noise, T, framerate, firerate, b, N, seed); 
y = Y(1,:);
plot(y);