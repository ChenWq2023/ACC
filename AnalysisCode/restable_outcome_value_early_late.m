%% Restable nogocue 
clear
file=dir('ACC*restable*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
     n=length(outcome);n1=fix(n*0.15);
    early=[find(outcome(1:n1,1)==3);find(outcome(1:n1,1)==4);];%early phase
    late=[find(outcome(n1+1:n,1)==3);find(outcome(n1+1:n,1)==4)]+n1;%late phase
    for i=1:Info.Cellnumber  
        total=eachDF{1, i}(46:90,:);
        nogocue.earlyDF{k}=total(:,early);
        nogocue.earlyZ{k}=(nogocue.earlyDF{k}-mean(nogocue.earlyDF{k}(1:15,:)))./std(nogocue.earlyDF{k}(1:15,:));
        nogocue.lateDF{k}=total(:,late);
        nogocue.lateZ{k}=(nogocue.lateDF{k}-mean(nogocue.lateDF{k}(1:15,:)))./std(nogocue.lateDF{k}(1:15,:));
        k=k+1;
    end
    clearvars -except nogocue k jj file
end
%restable FA outcome
clearvars -except nogocue 
file=dir('ACC*restable*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
    n=length(outcome);
    n1=fix(n*0.15);
    early_fa=find(outcome(1:n1,1)==4);%early phase
    late_fa=find(outcome(n1+1:n,1)==4)+n1;%late phase
    if length([early_fa;late_fa])<=1
        early_fa=[];later_fa=[];
    elseif length([early_fa;late_fa])>1 && isempty(early_fa) %if eaely no fa, select first fa
        early_fa=late_fa(1);
        late_fa(1)=[];
    end
    for j=1:Info.Cellnumber
        if isempty(early_fa)
            punishment.FAearlyZ{k}=nan(45,1);
            punishment.FAlateZ{k}=nan(45,1);
            punishment.FAearlyDF{k}=nan(45,1);
            punishment.FAlateDF{k}=nan(45,1);
        else
            early_fadf=eachDF{j}(:,early_fa);
            late_fadf=eachDF{j}(:,late_fa);
            for i=1:length(early_fa)
                punishtime=outcome(early_fa,2)+60;%60f baseline
                punishment.FAearlyDF{k}(:,i)=early_fadf(punishtime(i)-14:punishtime(i)+30,i);
            end
            punishment.FAearlyZ{k}=(punishment.FAearlyDF{k}-mean(punishment.FAearlyDF{k}(1:15,:)))./std(punishment.FAearlyDF{k}(1:15,:));
            for i=1:length(late_fa)
                punishtime=outcome(late_fa,2)+60;%60f baseline
                punishment.FAlateDF{k}(:,i)=late_fadf(punishtime(i)-14:punishtime(i)+30,i);
            end
            punishment.FAlateZ{k}=(punishment.FAlateDF{k}-mean(punishment.FAlateDF{k}(1:15,:)))./std(punishment.FAlateDF{k}(1:15,:)); 
        end
        k=k+1;
    end
    clearvars -except file punishment k nogocue
end
save('restable_value_outcome_population','nogocue','punishment')