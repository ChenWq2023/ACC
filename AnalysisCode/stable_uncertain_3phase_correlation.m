clear
file=dir('ACC*uncertain*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
    n=length(outcome);
    n1=fix(n*0.33);n2=fix(n*0.67);
    go1=[find(outcome(1:n1,1)==1);find(outcome(1:n1,1)==2);find(outcome(1:n1,1)==5)];
    go2=[find(outcome(n1+1:n2,1)==1);find(outcome(n1+1:n2,1)==2);find(outcome(n1+1:n2,1)==5)]+n1;
    go3=[find(outcome(n2+1:end,1)==1);find(outcome(n2+1:end,1)==2);find(outcome(n2+1:end,1)==5)]+n2;
    nogo1=[find(outcome(1:n1,1)==3);find(outcome(1:n1,1)==4)];
    nogo2=[find(outcome(n1+1:n2,1)==3);find(outcome(n1+1:n2,1)==4)]+n1;
    nogo3=[find(outcome(n2+1:end,1)==3);find(outcome(n2+1:end,1)==4)]+n2;
    for i=1:Info.Cellnumber
        total=eachDF{1, i}(61:90,:)  ;
        uncertain.go1{k}=total(:,go1);uncertain.go2{k}=total(:,go2);uncertain.go3{k}=total(:,go3);
        uncertain.nogo1{k}=total(:,nogo1);uncertain.nogo2{k}=total(:,nogo2);uncertain.nogo3{k}=total(:,nogo3);
        k=k+1;
    end
    clearvars -except uncertain k jj file
end
load('stable.mat')
for i=1:549
    st=[population.goHit.eachDF{i}(61:90,:) population.goMiss.eachDF{i}(61:90,:)];
    stable.go{i}=st;
    clear st
    st=[population.nogoCR.eachDF{i}(61:90,:) population.nogoFA.eachDF{i}(61:90,:)];
    stable.nogo{i}=st;
end
for i=1:549
    goR(i,1)=mean(mean(stable.go{i}),'omitnan'); 
    goR(i,2)=mean(mean(uncertain.go1{i}),'omitnan');
    goR(i,3)=mean(mean(uncertain.go2{i}),'omitnan');
    goR(i,4)=mean(mean(uncertain.go3{i}),'omitnan');
    nogoR(i,1)=mean(mean(stable.nogo{i}),'omitnan');
    nogoR(i,2)=mean(mean(uncertain.nogo1{i}),'omitnan');
    nogoR(i,3)=mean(mean(uncertain.nogo2{i}),'omitnan');
    nogoR(i,4)=mean(mean(uncertain.nogo3{i}),'omitnan');
end
[cor.go,P.go] = corrcoef(goR,'Rows','pairwise');%go corraletion
[cor.nogo,P.nogo] = corrcoef(nogoR,'Rows','pairwise');%nogo corraletion
save('uncertain_3phase_correlation','goR','nogoR','cor','P')
