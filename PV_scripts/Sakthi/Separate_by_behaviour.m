function [C]=Separate_by_behaviour(neuron);
sf=5;
binz=2;
ts=1;


C{1}=neuron.S(:,1:3000);
C{1}=moving_mean(C{1},sf,binz,ts,0);


C{2}=neuron.S(:,3001:6000);
C{2}=moving_mean(C{2},sf,binz,ts,0);


C{3}=neuron.S(:,6001:7500);
C{3}=moving_mean(C{3},sf,binz,ts,0);
% 
% sleepdata=separate_by_sleep(neuron.S(:,7501:52500),hypno(7501:52500));
% C{4}=sleepdata.rem;
% C{4}=moving_mean(C{4},sf,binz,ts,0);

C{4}=neuron.S(:,52501:55500);
C{4}=moving_mean(C{4},sf,binz,ts,0);

C{5}=neuron.S(:,55501:58500);
C{5}=moving_mean(C{5},sf,binz,ts,0);
