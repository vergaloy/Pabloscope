function choose_lambda(X)






















%% Procedure for choosing lambda
nLambdas = 300; % increase if you're patient
K = 8;
%X = trainNEURAL;
lambdas = sort([logspace(-1,-5,nLambdas)], 'ascend');
regularization = [];
cost = [];
loop=length(lambdas);
[N,T] = size(X);
for r=1:100
    display(['Testing lambda, loop: ' num2str(r) '/' num2str(100)])
    parfor li = 1:loop
        [W,H]= seqNMF(X,'K',K,'L',1,...
            'lambdaL1W', 0, 'lambda', lambdas(li), 'maxiter', 100, 'showPlot', 0,'lambdaOrthoW',1);
        [cost(r,li),regularization(r,li),~] = helper.get_seqNMF_cost(X,W,H); 
    end
end
%% plot costs as a function of lambda
cost=mean(cost,1);
regularization=mean(regularization,1);

windowSize = 80; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;
Rs = filtfilt(b,a,regularization); 
minRs = prctile(regularization,1); maxRs= prctile(regularization,99);
Rs = (Rs-minRs)/(maxRs-minRs); 
R = (regularization-minRs)/(maxRs-minRs); 
Cs = filtfilt(b,a,cost); 
minCs =  prctile(cost,1); maxCs =  prctile(cost,99); 
Cs = (Cs -minCs)/(maxCs-minCs); 
C = (cost -minCs)/(maxCs-minCs); 

clf; hold on
plot(lambdas,Rs, 'b')
plot(lambdas,Cs,'r')
scatter(lambdas, R, 'b', 'markerfacecolor', 'flat');
scatter(lambdas, C, 'r', 'markerfacecolor', 'flat');
xlabel('Lambda'); ylabel('Cost (au)')
set(legend('Correlation cost', 'Reconstruction cost'), 'Box', 'on')
set(gca, 'xscale', 'log', 'ytick', [], 'color', 'none')
set(gca,'color','none','tickdir','out','ticklength', [0.025, 0.025])