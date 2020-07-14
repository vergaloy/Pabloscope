function compare_performance(T,R)
% compare_performance(out{1, 5},out{1, 1});
C=T-R;
C=mean(C,3);
C=C+C';
values = {'HC1','HC2','PreS','PreS2','PostS','REM','HT','LT','NREM','A','A2','C','C2'};

[B,~]=Bhattacharyya_coefficient_matrix(T,R);
plot_heatmap_PV(C,B,values,'Change in accuracy','money')



end

function [B,DB]=Bhattacharyya_coefficient_matrix(A,B)
m1=mean(A,3);
m2=mean(B,3);
v1=var(A,[],3);
v2=var(B,[],3);
DB=0.25*log(0.25.*(v1./v2+v2./v1+2))+0.25*(((m1-m2).^2)./(v1+v2));
DB(isnan(DB))=0;
DB=DB+DB';
B=exp(-DB);
end