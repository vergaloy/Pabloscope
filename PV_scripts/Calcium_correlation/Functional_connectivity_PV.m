function [W,H]=Functional_connectivity_PV(neuron);

C{1}=neuron.S(:,1:3000);
C{1}=moving_mean(C{1},5,30,30,0);
[W{1},H{1}]=Get_connectivity(HC);

C{2}=neuron.S(:,3001:6000);
C{2}=moving_mean(C{2},10,5,30,0);
[W{2},H{2}]=Get_connectivity(Train);

C{3}=neuron.S(:,6001:7500);
C{3}=moving_mean(C{3},5,30,30,0);
[W{3},H{3}]=Get_connectivity(A);
sleepdata=separate_by_sleep(neuron.S(:,7501:52500),hypno(7501:52500));
C{4}=sleepdata.rem;
C{4}=moving_mean(C{4},5,30,30,0);
[W{4},H{4}]=Get_connectivity(C);

C{5}=neuron.S(:,52501:55500);
C{5}=moving_mean(C{5},5,5,30,0);
[W{5},H{5}]=Get_connectivity(B);

dummy=1;