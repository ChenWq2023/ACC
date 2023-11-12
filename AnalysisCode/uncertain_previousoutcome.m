clear
file=dir('ACC*uncertain*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
    gotrial=find(outcome(:,1)==1|outcome(:,1)==2|outcome(:,1)==5);%Go trial,hit/miss/ro
    %delte first trial
    gotrial(find(gotrial<=1))=[];
    nogotrial=find(outcome(:,1)==3|outcome(:,1)==4);%Nogo trial,cr/fa
    nogotrial(find(nogotrial<=1))=[];
    previous_trial_g=outcome(gotrial-1,1);%previous trial
    normal_trial_g=find(previous_trial_g==1|previous_trial_g==2|previous_trial_g==3|previous_trial_g==4);%normal trial
    unexpect_trial_g=find(previous_trial_g==5|previous_trial_g==6);%unexpect trial
    ro_trial_g=find(previous_trial_g==5);%ro trial
    ur_trial_g=find(previous_trial_g==6);%ur trial
    NT_g=gotrial(normal_trial_g);NT_g(:,2)=outcome(NT_g,1);
    UT_g=gotrial(unexpect_trial_g);UT_g(:,2)=outcome(UT_g,1);
    ro_g=gotrial(ro_trial_g);ro_g(:,2)=outcome(ro_g,1);
    ur_g=gotrial(ur_trial_g);ur_g(:,2)=outcome(ur_g,1);
    
    previous_trial_ng=outcome(nogotrial-1,1);%NOGO previous trial
    normal_trial_ng=find(previous_trial_ng==1|previous_trial_ng==2|previous_trial_ng==3|previous_trial_ng==4);
    unexpect_trial_ng=find(previous_trial_ng==5|previous_trial_ng==6);
    NT_ng=nogotrial(normal_trial_ng);NT_ng(:,2)=outcome(NT_ng,1);
    UT_ng=nogotrial(unexpect_trial_ng);UT_ng(:,2)=outcome(UT_ng,1);
    % hitrate
    hitrate.nt_g(jj,1)=100-length(find(NT_g(:,2)==2))/length(NT_g)*100;
    hitrate.ut_g(jj,1)=100-length(find(UT_g(:,2)==2))/length(UT_g)*100;
    hitrate.ro_g(jj,1)=100-length(find(ro_g(:,2)==2))/length(ro_g)*100;
    hitrate.ur_g(jj,1)=100-length(find(ur_g(:,2)==2))/length(ur_g)*100;
    %farate
    farate.nt_ng(jj,1)=length(find(NT_ng(:,2)==4))/length(NT_ng)*100;
    farate.ut_ng(jj,1)=length(find(UT_ng(:,2)==4))/length(UT_ng)*100;
    for i=1:Info.Cellnumber
        total=eachDF{i}(46:90,:);
        previousoutcome.nt_g(:,k)=mean(total(:,NT_g(:,1)),2);
        previousoutcome.ut_g(:,k)=mean(total(:,UT_g(:,1)),2);
        
        previousoutcome.ro_g(:,k)=mean(total(:,ro_g(:,1)),2);
        previousoutcome.ur_g(:,k)=mean(total(:,ur_g(:,1)),2);
        
        previousoutcome.nt_ng(:,k)=mean(total(:,NT_ng(:,1)),2);
        previousoutcome.ut_ng(:,k)=mean(total(:,UT_ng(:,1)),2);
        k=k+1;
    end
    clearvars -except  previousoutcome k jj file hitrate farate
end
%normalized to -0.5~0 s
previousoutcome.ntZ_g=(previousoutcome.nt_g-mean(previousoutcome.nt_g(1:15,:)))./std(previousoutcome.nt_g(1:15,:));
previousoutcome.utZ_g=(previousoutcome.ut_g-mean(previousoutcome.ut_g(1:15,:)))./std(previousoutcome.ut_g(1:15,:));
previousoutcome.roZ_g=(previousoutcome.ro_g-mean(previousoutcome.ro_g(1:15,:)))./std(previousoutcome.ro_g(1:15,:));
previousoutcome.urZ_g=(previousoutcome.ur_g-mean(previousoutcome.ur_g(1:15,:)))./std(previousoutcome.ur_g(1:15,:));
previousoutcome.ntZ_ng=(previousoutcome.nt_ng-mean(previousoutcome.nt_ng(1:15,:)))./std(previousoutcome.nt_ng(1:15,:));
previousoutcome.utZ_ng=(previousoutcome.ut_ng-mean(previousoutcome.ut_ng(1:15,:)))./std(previousoutcome.ut_ng(1:15,:));
save('uncertain_previousoutcome','previousoutcome','hitrate','farate')
