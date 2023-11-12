clear
file=dir('ACC*restable*.mat');
k1=1;k2=1;
for jj=1:length(file)
    load(file(jj).name)
    nogotrial=find(outcome(:,1)==3|outcome(:,1)==4);%Nogo trial,cr/fa
    nogotrial(find(nogotrial<=1))=[];
    previous_trial_ng=outcome(nogotrial-1,1);%NOGO previous trial
    FA_trial_ng=find(previous_trial_ng==4);%%FA
    nonFA_trial_ng=find(previous_trial_ng~=4);%%non-FA
    FA_ng=nogotrial(FA_trial_ng);FA_ng(:,2)=outcome(FA_ng,1);
    nonFA_ng=nogotrial(nonFA_trial_ng);nonFA_ng(:,2)=outcome(nonFA_ng,1);
    %farate
    farate.fa_ng(jj,1)=length(find(FA_ng(:,2)==4))/length(FA_ng(:,2))*100;
    farate.nonfa_ng(jj,1)=length(find(nonFA_ng(:,2)==4))/length(nonFA_ng(:,2))*100;
    for i=1:Info.Cellnumber
       total=eachDF{i}(46:90,:);
        if isempty(FA_trial_ng) || isempty(nonFA_trial_ng)
            previousoutcome.fa_ng(:,k1)=nan(45,1);previousoutcome.nonfa_ng(:,k1)=nan(45,1);
            k1=k1+1;
        else
            previousoutcome.fa_ng(:,k1)=mean(total(:,FA_ng(:,1)),2);previousoutcome.nonfa_ng(:,k1)=mean(total(:,nonFA_ng(:,1)),2);
            k1=k1+1;
        end
    end
    clearvars -except previousoutcome k1 jj file farate
end
%normalized to -0.5~0 s
previousoutcome.faZ_ng=(previousoutcome.fa_ng-mean(previousoutcome.fa_ng(1:15,:)))./std(previousoutcome.fa_ng(1:15,:));
previousoutcome.nonfaZ_ng=(previousoutcome.nonfa_ng-mean(previousoutcome.nonfa_ng(1:15,:)))./std(previousoutcome.nonfa_ng(1:15,:));
save('restable_previousoutcome_fa','previousoutcome','farate')