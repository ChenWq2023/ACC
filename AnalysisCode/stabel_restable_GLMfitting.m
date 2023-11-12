clear
file=dir('ACC*restable*.mat');
k=1;
for jj=1:5
    load(file(jj).name)
    gotrial=find(outcome(:,1)==1|outcome(:,1)==2);%GO trial
    gotrial(find(gotrial<6))=[];%form 6th trial
    gotrial(27:end,:)=[];%uniform trial number,total 26 trials
    Previoustrial=ones(length(gotrial),5);
    for ik=1:5
        previoustrial=outcome(gotrial-ik,1);%previous 5 trial
        reward_trial=find(previoustrial==1);
        Previoustrial(reward_trial,ik)=0;
    end
    for ii=1:Info.Cellnumber   
        total=eachDF{ii}(46:90,gotrial);
        totalZ=(total-mean(total(1:15,:)))./std(total(1:15,:));
        response{k}=mean(totalZ(16:45,:))';
        variable{k}=Previoustrial;
        k=k+1;
    end
end
%glmfit
for i=1:length(variable)
    mdl=fitlm(variable{i},response{i},'linear');
    coeff(i,:)=table2array(mdl.Coefficients(:,1))';
    R(i,:)=mdl.Rsquared.Ordinary ;
    temp=anova(mdl,'summary');
    pvalue(i,:)=table2array(temp(2,5));
end
coeff=coeff(:,2:6);%coeff(:,1)is intercept
for i=1:5
    p(1,i)=signrank(coeff(:,i));
end
save('restable_GLMfitting','variable','response','coeff','R','p','pvalue')
clear

file=dir('ACC*stable*.mat');
k=1;
for jj=1:5
    load(file(jj).name)
    gotrial=find(outcome(:,1)==1|outcome(:,1)==2);%GO trial
    gotrial(find(gotrial<6))=[];%form 6th trial
    gotrial(27:end,:)=[];%uniform trial number,total 26 trials
    Previoustrial=ones(length(gotrial),5);
    for ik=1:5
        pre_trial=outcome(gotrial-ik,1);%previous 5 trial
        reward_trial=find(pre_trial==1);
        Previoustrial(reward_trial,ik)=0;
    end
    for ii=1:Info.Cellnumber   
        total=eachDF{ii}(46:90,gotrial);
        totalZ=(total-mean(total(1:15,:)))./std(total(1:15,:));
        response{k}=mean(totalZ(16:45,:))';
        variable{k}=Previoustrial;
        k=k+1;
    end
end
% glmfit
for i=1:length(variable)
    mdl=fitlm(variable{i},response{i},'linear');
    coeff(i,:)=table2array(mdl.Coefficients(:,1))';
    R(i,:)=mdl.Rsquared.Ordinary ;
    temp=anova(mdl,'summary');
    pvalue(i,:)=table2array(temp(2,5));
end

coeff=coeff(:,2:6);%coeff(:,1)is intercept
for i=1:5
    p(1,i)=signrank(coeff(:,i));
end
save('stable_GLMfitting','variable','response','coeff','R','p','pvalue')
clear
restable=load('restable_GLMfitting.mat');
stable=load('stable_GLMfitting.mat');

for i=1:5
    [p1(1,i),~,s]=signrank(stable.coeff(:,i));
    z1(1,i)=s.zval;
    [p2(1,i),~,s]=signrank(restable.coeff(:,i));
     z2(1,i)=s.zval;
    [p3(1,i),~,s]=ranksum(abs(stable.coeff(:,i)),abs(restable.coeff(:,i)));
    z3(1,i)=s.zval;
end


