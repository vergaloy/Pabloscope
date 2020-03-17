function [W,H,indSort]=Get_seqNMF(C,exclud,K)
% [W,H,indsort]=Get_seqNMF(C,[1,6,7],8);
X=[];
t=0;
for i=1:size(C,2)
    if (~ismember(i,exclud))
        X=[X,full(C{1,i})];
        t=t+1;
        siz(t)=size(C{1,i},2);
    end
end


X=X./max(X,[],2);
X(isnan(sum(X,2)),:)=0;

if (K==0)
numfits = 10; %number of fits to compare
inds = nchoosek(1:numfits,2);
n=size(inds,1);
rep=10;
for k = 1:rep
    fprintf('running seqNMF with K = %i\n',k)
    for ii = 1:numfits
        
        [W0,H0]=intial_seqNMF(X,k);
        [Ws{ii,k},Hs{ii,k}] = seqNMF(X,'K',k, 'L', 1,'lambda', 0,'maxiter',100,'showplot',0,'lambdaOrthoW',1, 'W_init',W0, 'H_init',H0);
    end
    parfor i = 1:n % consider using parfor for larger numfits
        Diss(i,k) = helper.DISSX(Hs{inds(i,1),k},Ws{inds(i,1),k},Hs{inds(i,2),k},Ws{inds(i,2),k});
    end
end
%% Plot Diss and choose K with the minimum average diss.
figure,
plot(1:rep,Diss,'ko'), hold on
h1 = plot(1:rep,median(Diss,1),'k-','linewidth',2);
xlabel('K')
ylabel('Diss')
while (K==0)
K = input('Input best K value: ');
end
end


L = 1;
lambda =0.6;
[W0,H0]=intial_seqNMF(X,K);
[W,H] = seqNMF(X,'K',K, 'L', L,'lambda', lambda,'tolerance',1e-4,'lambdaL1W',0,'showPlot',0,'lambdaOrthoW',1,'W_init',W0, 'H_init',H0);

display('Testing significance of factors on held-out data')
[pvals,is_significant] = test_significance(X,W,0.05);

W = W(:,is_significant,:);
H = H(is_significant,:);

[max_factor, L_sort, max_sort, hybrid] = helper.ClusterByFactor(W(:,:,:),1);
indSort = hybrid(:,3);
figure; SimpleWHPlot(W(indSort,:,:),H,X(indSort,:)); title('SeqNMF factors, with raw data')
t=0;
for i=1:size(siz,2)
    t=t+siz(i);
    xline(t)
end