function W=get_pattern_cells_from_NMF(W,n)
temp=reshape(W,[1,size(W,1)*size(W,2)]);
temp(temp<mean(temp)+2*median(abs(temp))/0.6745)=0;
W=reshape(temp,[size(W,1),size(W,2)]);
t=W;
t(t>0)=1;
t=sum(t,1);
W(:,t<n)=[];
end