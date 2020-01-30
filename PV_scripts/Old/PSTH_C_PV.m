function  PSTH=PSTH_C_PV(neuron,make_trials,stimulus_onset,stimulus_duration,Trial_duration,discard)
%eg. PSTH=PSTH_C_PV(neuron,1,30,30,90,0);

if nargin<2
 make_trials=0;
 stimulus_onset=10;
 stimulus_duration=10;
 Trial_duration=30;
 discard=0;  
 sort_by_P=0;
end

path=neuron.C;
PSTH.Fs=neuron.Fs;
PSTH.frame_range=size(neuron.C,2);
PSTH.C=full(path);
% if(path==neuron.S)
%     PSTH.C(PSTH.C>0)=1;
% end
m=max(PSTH.C(:));
PSTH.C=PSTH.C/m;
trials=floor((PSTH.frame_range/PSTH.Fs)/(Trial_duration));
if(make_trials==1)
    temp(1:size(neuron.C,1),1:floor(PSTH.Fs*(Trial_duration)))=0;
    trail_data=0;
    PSTH.C=PSTH.C(:,1:floor(trials*Trial_duration*PSTH.Fs));
    PSTH.frame_range=size(PSTH.C,2);
    for t=1:trials
        start_x=floor((t-1)*PSTH.Fs*(Trial_duration)+1);
        end_x=start_x+floor(PSTH.Fs*(Trial_duration)-1);
        temp=temp+PSTH.C(1:size(PSTH.C,1),start_x:end_x);
        trail_data((t-1)*Trial_duration+stimulus_onset:(t-1)*Trial_duration+stimulus_onset+stimulus_duration)=1;
    end
    PSTH.C=temp;
    PSTH.frame_range=size(PSTH.C,2);
end

if (discard==1)
    
    for n=1:size(neuron.S,1)
        t1=PSTH.C(n,1:stimulus_onset*PSTH.Fs);
        PSTH.activity(n)=(mean(t1));
    end
    [h,in]=sort(PSTH.activity,'descend');
    
    for n=1:size(PSTH.C,1)
        PSTH.C2(n,1:size(PSTH.C,2))=PSTH.C(in(n),:);
    end
    PSTH.C=PSTH.C2;
    clear PSTH.C2
    PSTH.C(h<0.01,:)=[];
    PSTH.activity=[];
end


for n=1:size(PSTH.C,1)
    t1=PSTH.C(n,1:floor(stimulus_onset*PSTH.Fs));
    t2=PSTH.C(n,floor((stimulus_onset)*PSTH.Fs+1):floor((stimulus_onset+stimulus_duration)*PSTH.Fs));
    [~,p]=ttest2(t1,t2);
    PSTH.P(n)=p;
    PSTH.activity(n)=(mean(t1)-mean(t2));
end
if (sort_by_P==1)
    [~,in]=sort(PSTH.P,'ascend');
else
    [~,in]=sort(PSTH.activity,'ascend');
end
for n=1:size(PSTH.C,1)
    PSTH.C_sorted(n,1:size(PSTH.C,2))=PSTH.C(in(n),:);
end

PSTH.C_sorted=PSTH.C_sorted/trials;

x=(-stimulus_onset:1/PSTH.Fs:(PSTH.frame_range/PSTH.Fs)-stimulus_onset-1/PSTH.Fs);
y=(1:size(PSTH.C,1));
PSTH.CTotal=sum(PSTH.C,1)/size(PSTH.C,1);


h=imagesc(x,y,PSTH.C_sorted);
%%set(h, 'XData', [-120 60]);
colormap('hot')
xticks(-120:30:(PSTH.frame_range/PSTH.Fs)-stimulus_onset-1/PSTH.Fs);

hold on
x1=0;
x2=stimulus_duration;
y1=0;
y2=size(neuron.C,1)+1;
x = [x1, x2, x2, x1, x1];
y = [y1, y1, y2, y2, y1];
plot(x, y, 'b-', 'LineWidth', 3);

figure
x=(-stimulus_onset:1/PSTH.Fs:(PSTH.frame_range/PSTH.Fs)-stimulus_onset-1/PSTH.Fs);
b=bar(x,PSTH.CTotal,'histc','EdgeColor','black','FaceColor','black');
set(b,'EdgeColor','k')




