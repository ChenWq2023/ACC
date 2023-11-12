clear
file=dir('ACC*restable*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
    n=length(outcome);
    n1=fix(n*0.33);n2=fix(n*0.67);
    go1=find(outcome(1:n1,1)==1|outcome(1:n1,1)==2);
    go2=find(outcome(n1+1:n2,1)==1|outcome(n1+1:n2,1)==2)+n1;
    go3=find(outcome(n2+1:end,1)==1|outcome(n2+1:end,1)==2)+n2;

    for i=1:Info.Cellnumber
        total=eachDF{i}(61:90,:);
        restable.go1{k}=total(:,go1);restable.go2{k}=total(:,go2);restable.go3{k}=total(:,go3);
    
        k=k+1;
    end
    clearvars -except restable k jj file
end
for i=1:493
    goR.restable(i,1)=mean(mean(restable.go1{i}),'omitnan');
    goR.restable(i,2)=mean(mean(restable.go2{i}),'omitnan');
    goR.restable(i,3)=mean(mean(restable.go3{i}),'omitnan');
end

file=dir('ACC*stable*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
   n=length(outcome);
    n1=fix(n*0.33);n2=fix(n*0.67);
    go1=find(outcome(1:n1,1)==1|outcome(1:n1,1)==2);
    go2=find(outcome(n1+1:n2,1)==1|outcome(n1+1:n2,1)==2)+n1;
    go3=find(outcome(n2+1:end,1)==1|outcome(n2+1:end,1)==2)+n2;
    for i=1:Info.Cellnumber
        total=eachDF{i}(61:90,:);  
        stable.go1{k}=total(:,go1);stable.go2{k}=total(:,go2);stable.go3{k}=total(:,go3);
        k=k+1;
    end
    clearvars -except stable k jj file goR 
end
for i=1:493
    goR.stable(i,1)=mean(mean(stable.go1{i}),'omitnan');
    goR.stable(i,2)=mean(mean(stable.go2{i}),'omitnan');
    goR.stable(i,3)=mean(mean(stable.go3{i}),'omitnan');
end

[cor.stable_restable,P.stable_restable] = corrcoef([goR.stable goR.restable],'Rows','pairwise');
save('stable_restable_correlation','cor','goR')