tic  %Start timer
%%clear all %delte all variables
%% Pre-Sets: These are the user-defined variables.  
clear PSTH

stimulus=120; %%in s
stimulus_off=180;
PSTH.Fs=neuron.Fs;
PSTH.frame_range=neuron.frame_range(2);
PSTH.C=full(neuron.C);
m=max(PSTH.C(:));
PSTH.C=PSTH.C/m;
discard=1;

if (discard==0);

for n=1:size(neuron.S,1)
    t1=PSTH.C(n,1:stimulus*PSTH.Fs);
    PSTH.activity(n)=(mean(t1));
end
[h,in]=sort(PSTH.activity,'descend');

for n=1:size(PSTH.C,1)
PSTH.C2(n,1:size(PSTH.C,2))=PSTH.C(in(n),:);
end
PSTH.C=PSTH.C2;
clear PSTH.C2
PSTH.C(h<0.002,:)=[];
PSTH.activity=[];
end


for n=1:size(PSTH.C,1)
    t1=PSTH.C(n,1:stimulus*PSTH.Fs);
    t2=PSTH.C(n,(stimulus+5)*PSTH.Fs:stimulus_off*PSTH.Fs);
    [~,p]=ttest2(t1,t2);
    PSTH.P(n)=p;
    PSTH.activity(n)=(mean(t2));
end
[~,in]=sort(PSTH.activity,'ascend');
for n=1:size(PSTH.C,1)
PSTH.C_sorted(n,1:size(PSTH.C,2))=PSTH.C(in(n),:);
end

x=(-stimulus:1/PSTH.Fs:(PSTH.frame_range/PSTH.Fs)-stimulus-1/PSTH.Fs);
y=(1:size(PSTH.C,1));
PSTH.CTotal=sum(PSTH.C,1)/size(PSTH.C,1);


h=imagesc(x,y,PSTH.C_sorted,[0 1]);
%%set(h, 'XData', [-120 60]);
colormap('hot')
xticks(-120:30:(PSTH.frame_range/PSTH.Fs)-stimulus-1/PSTH.Fs);
figure
plot(x,PSTH.CTotal);
xticks(-120:30:(PSTH.frame_range/PSTH.Fs)-stimulus-1/PSTH.Fs);
