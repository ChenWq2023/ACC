clear
file=dir('ACC*reverse*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
  n=length(outcome);
    n1=fix(n*0.15);n2=fix(n*0.50);
    go1=[find(outcome(1:n1,1)==1);find(outcome(1:n1,1)==2);find(outcome(1:n1,1)==5)];
    go2=[find(outcome(n1+1:n2,1)==1);find(outcome(n1+1:n2,1)==2);find(outcome(n1+1:n2,1)==5)]+n1;
    go3=[find(outcome(n2+1:end,1)==1);find(outcome(n2+1:end,1)==2);find(outcome(n2+1:end,1)==5)]+n2;
    nogo1=[find(outcome(1:n1,1)==3);find(outcome(1:n1,1)==4)];
    nogo2=[find(outcome(n1+1:n2,1)==3);find(outcome(n1+1:n2,1)==4)]+n1;
    nogo3=[find(outcome(n2+1:end,1)==3);find(outcome(n2+1:end,1)==4)]+n2;

    for i=1:Info.Cellnumber
        total=eachDF{1, i}(61:90,:)  ;
        reverse.go1{k}=total(:,go1);reverse.go2{k}=total(:,go2);reverse.go3{k}=total(:,go3);
        reverse.nogo1{k}=total(:,nogo1);reverse.nogo2{k}=total(:,nogo2);reverse.nogo3{k}=total(:,nogo3);
        k=k+1;
    end
    clearvars -except reverse k jj file
end
load('stable.mat')
for i=1:493
    st=[population.goHit.eachDF{i}(61:90,:) population.goMiss.eachDF{i}(61:90,:)];
    stable.go{i}=st;
    clear st
    st=[population.nogoCR.eachDF{i}(61:90,:) population.nogoFA.eachDF{i}(61:90,:)];
    stable.nogo{i}=st;
end
for i=1:493
    T_3kR(i,1)=mean(mean(stable.go{i}),'omitnan'); 
    T_3kR(i,2)=mean(mean(reverse.nogo1{i}),'omitnan');
    T_3kR(i,3)=mean(mean(reverse.nogo2{i}),'omitnan');
    T_3kR(i,4)=mean(mean(reverse.nogo3{i}),'omitnan');
    T_12kR(i,1)=mean(mean(stable.nogo{i}),'omitnan');
    T_12kR(i,2)=mean(mean(reverse.go1{i}),'omitnan');
    T_12kR(i,3)=mean(mean(reverse.go2{i}),'omitnan');
    T_12kR(i,4)=mean(mean(reverse.go3{i}),'omitnan');
end
[cor.T_3k,P.go] = corrcoef(T_3kR,'Rows','pairwise');%3khz corraletion
[cor.T_12k,P.nogo] = corrcoef(T_12kR,'Rows','pairwise');%12khz corraletion
save('reverse_3phase_correlation','T_3kR','T_12kR','cor','P')
