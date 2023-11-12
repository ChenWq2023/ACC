clear
file=dir('ACC*restable*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
    gotrial=find(outcome(:,1)==1|outcome(:,1)==2);%Go trial,hit/miss
    gotrial(find(gotrial<=1),:)=[]; %delte first trial
    
    previous_trial_g=outcome(gotrial-1,1);%previous trial
    reward_trial_g=find(previous_trial_g==1);%hit trial
    nonreward_trial_g=find(previous_trial_g~=1);%nonhit trial
  
    R_g=gotrial(reward_trial_g);R_g(:,2)=outcome(reward_trial_g,1);
    NR_g=gotrial(nonreward_trial_g);NR_g(:,2)=outcome(nonreward_trial_g,1);
   
    for i=1:Info.Cellnumber
        total=eachDF{i}(46:90,:);
        previousoutcome.r_g(:,k)=mean(total(:,R_g(:,1)),2);
        previousoutcome.nr_g(:,k)=mean(total(:,NR_g(:,1)),2);
        k=k+1;
    end
    clearvars -except  previousoutcome k jj file 
end
%normalized to -0.5~0 s
previousoutcome.rZ_g=(previousoutcome.r_g-mean(previousoutcome.r_g(1:15,:)))./std(previousoutcome.r_g(1:15,:));
previousoutcome.nrZ_g=(previousoutcome.nr_g-mean(previousoutcome.nr_g(1:15,:)))./std(previousoutcome.nr_g(1:15,:));
save('restable_previousoutcome_reward','previousoutcome')

clear

file=dir('ACC*stable*.mat');
k=1;
for jj=1:5
    load(file(jj).name)
    gotrial=find(outcome(:,1)==1|outcome(:,1)==2);%Go trial,hit/miss
    if min(gotrial)==1 %delte first trial
        gotrial(find(gotrial==min(gotrial)))=[];
    end
    
    previous_trial_g=outcome(gotrial-1,1);%previous trial
    reward_trial_g=find(previous_trial_g==1);%hit trial
    nonreward_trial_g=find(previous_trial_g~=1);%nonhit trial
  
    R_g=gotrial(reward_trial_g);R_g(:,2)=outcome(reward_trial_g,1);
    NR_g=gotrial(nonreward_trial_g);NR_g(:,2)=outcome(nonreward_trial_g,1);
   
    for i=1:Info.Cellnumber
        total=eachDF{i}(46:90,:);
        previousoutcome.r_g(:,k)=mean(total(:,R_g(:,1)),2);
        previousoutcome.nr_g(:,k)=mean(total(:,NR_g(:,1)),2);
        k=k+1;
    end
    clearvars -except  previousoutcome k jj file 
end
%normalized to -0.5~0 s
previousoutcome.rZ_g=(previousoutcome.r_g-mean(previousoutcome.r_g(1:15,:)))./std(previousoutcome.r_g(1:15,:));
previousoutcome.nrZ_g=(previousoutcome.nr_g-mean(previousoutcome.nr_g(1:15,:)))./std(previousoutcome.nr_g(1:15,:));
save('stable_previousoutcome_reward','previousoutcome')