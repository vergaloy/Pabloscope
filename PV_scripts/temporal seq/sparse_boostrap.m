function [A,B,h,P]=sparse_boostrap(A,B,mc);
%[A,B,h,P]=sparse_boostrap(C{1,1},C{1,2},1);
sim=10000;
n=size(A,1);
bootstrap=zeros(n,sim);


for s=1:sim  
    Ab = datasample(A,size(A,2),2,'Replace',true);
    Bb = datasample(B,size(B,2),2,'Replace',true);
    bootstrap(:,s)=mean(Ab,2)-mean(Bb,2);
end
z=(bootstrap==0);
z=mean(z,2);
z=z>0.05;


clear textprogressbar
warning('off','all')
textprogressbar('Getting density kernel of boostrap samples: ');
for i=1:n
textprogressbar(i/n*100); 
temp=bootstrap(i,:);
[~,density,xmesh,~]=kde(temp,10000,-1,1);
density=density/max(density);
cpd=cumsum(density) ;
cpd=cpd/max(cpd);
P(i)=density(find(xmesh>0,1));
end
textprogressbar('done');


P(z)=1;

if (mc==1)
 [ind,~] = FDR(P,0.05,0);
else
    ind=find(P<0.05);
end

h=zeros(1,n); h(ind)=1;h=logical(h);
M=mean(bootstrap,2);M(M>0)=1;M(M<0)=-1;
M=M.*(1-P)';
[~,I]=sort(M);
h=h(I);
A=A(I,:);
B=B(I,:);
% P=P(I);


imagesc([A,B]);
hold on
x1=0;
x2=size(A,2)+size(B,2)+1;
y1=find(h==0,1);
y2=find(h==0,1,'last');
x = [x1, x2, x2, x1, x1];
y = [y1, y1, y2, y2, y1];
plot(x, y, 'r-', 'LineWidth', 1);





