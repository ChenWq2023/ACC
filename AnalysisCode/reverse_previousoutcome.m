clear
file=dir('ACC*reverse*.mat');
k1=1;k2=1;
for jj=1:length(file)
    load(file(jj).name)
    n=length(outcome);n1=fix(n*0.15);
%     outcome=outcome(1:n1,:);
    nogotrial=find(outcome(:,1)==3|outcome(:,1)==4);%Nogo trial,cr/fa
    nogotrial(find(nogotrial<=1))=[];
    previous_trial_ng=outcome(nogotrial-1,1);%NOGO previous trial
    FA_trial_ng=find(previous_trial_ng==4);%%FA
    nonFA_trial_ng=find(previous_trial_ng~=4);%%non-FA
    FA_ng=nogotrial(FA_trial_ng);FA_ng(:,2)=outcome(FA_ng,1);
    nonFA_ng=nogotrial(nonFA_trial_ng);nonFA_ng(:,2)=outcome(nonFA_ng,1);
    gotrial=[find(outcome(:,1)==1);find(outcome(:,1)==2)];%go trial
     gotrial(find(gotrial<=1))=[];
    previous_trial_g=outcome(gotrial-1,1);%previous trial
    FA_trial_g=find(previous_trial_g==4);%%FA
    nonFA_trial_g=find(previous_trial_g~=4);%%non-FA
    FA_g=gotrial(FA_trial_g);FA_g(:,2)=outcome(FA_g,1);
    nonFA_g=gotrial(nonFA_trial_g);nonFA_g(:,2)=outcome(nonFA_g,1);
    %farate
    farate.fa_ng(jj,1)=length(find(FA_ng(:,2)==4))/length(FA_ng(:,2))*100;
    farate.nonfa_ng(jj,1)=length(find(nonFA_ng(:,2)==4))/length(nonFA_ng(:,2))*100;
    % hitrate
    hitrate.fa_g(jj,1)=length(find(FA_g(:,2)==1))/length(FA_g)*100;
    hitrate.nonfa_g(jj,1)=length(find(nonFA_g(:,2)==1))/length(nonFA_g)*100;
    
    for i=1:Info.Cellnumber
        total=eachDF{i}(46:90,:);
        if isempty(FA_trial_ng) || isempty(nonFA_trial_ng)
            previousoutcome.fa_ng(:,k1)=nan(45,1);previousoutcome.nonfa_ng(:,k1)=nan(45,1);
            k1=k1+1;
        else
            previousoutcome.fa_ng(:,k1)=mean(total(:,FA_ng(:,1)),2);previousoutcome.nonfa_ng(:,k1)=mean(total(:,nonFA_ng(:,1)),2);
            k1=k1+1;
        end
        
        if isempty(FA_trial_g) || isempty(nonFA_trial_g)
            previousoutcome.fa_g(:,k2)=nan(45,1);previousoutcome.nonfa_g(:,k2)=nan(45,1);
            k2=k2+1;
        else
            previousoutcome.fa_g(:,k2)=mean(total(:,FA_g(:,1)),2);previousoutcome.nonfa_g(:,k2)=mean(total(:,nonFA_g(:,1)),2);
            k2=k2+1;
        end
    end
    clearvars -except previousoutcome k1 k2 jj file hitrate farate
end
%normalized to -0.5~0 s
previousoutcome.faZ_ng=(previousoutcome.fa_ng-mean(previousoutcome.fa_ng(1:15,:)))./std(previousoutcome.fa_ng(1:15,:));
previousoutcome.nonfaZ_ng=(previousoutcome.nonfa_ng-mean(previousoutcome.nonfa_ng(1:15,:)))./std(previousoutcome.nonfa_ng(1:15,:));
previousoutcome.faZ_g=(previousoutcome.fa_g-mean(previousoutcome.fa_g(1:15,:)))./std(previousoutcome.fa_g(1:15,:));
previousoutcome.nonfaZ_g=(previousoutcome.nonfa_g-mean(previousoutcome.nonfa_g(1:15,:)))./std(previousoutcome.nonfa_g(1:15,:));
save('reverse_previousoutcome','previousoutcome','hitrate','farate')