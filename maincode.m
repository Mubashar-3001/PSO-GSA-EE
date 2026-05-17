clear all
close all
clc
% global alpha
% alpha=0.1*6
% for run=1:2
%    %alpha=0.1*i
% tic;
%     [Gbest,Val_Gbest_rec]=ORPD
% time=toc;
%     x(run,:)=[Gbest,min(Val_Gbest_rec),time];
% save dataset
% end

for run=1:2 % actual is 50, numbeer of runs;
   %alpha=0.1*i
tic;
    [gBest,GlobalBestCost]=Main
time=toc;
    x(run,:)=[GlobalBestCost,time];
    y(run,:)=[gBest];
save dataset_DOCR_3bus_FPSOGSA_EE_a=test.mat % where to save file, change numbering after every go;
end
