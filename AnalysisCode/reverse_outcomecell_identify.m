clear
file=dir('ACC*reverse*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
    n=length(outcome);
    n1=fix(n*0.15);
    early_fa=find(outcome(1:n1,1)==4);%early phase
    late_fa=find(outcome(n1+1:n,1)==4)+n1;%late phase
    for j=1:Info.Cellnumber
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
        k=k+1;
        end
        
        clearvars -except file punishment  k
end
for ii=1:493
    y1=punishment.FAearlyZ{ii}(16:45,:);
    y2=punishment.FAlateZ{ii}(16:45,:);
    outcome.index(ii,:)=cellidentify(y1,y2,2,2);
end
outcome.cell=find(outcome.index==1);
save('reverse_outcomecell_identify','punishment','outcome')