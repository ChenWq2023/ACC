clear
file=dir('ACC*uncertain*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
    n=length(outcome);
    n1=fix(n*0.67);
    early_g=[find(outcome(1:n1,1)==1);find(outcome(1:n1,1)==2);find(outcome(1:n1,1)==5)];%early phase
    late_g=[find(outcome(n1+1:n,1)==1);find(outcome(n1+1:n,1)==2);find(outcome(n1+1:n,1)==5)]+n1;%late phase
    for i=1:Info.Cellnumber
        total=eachDF{1, i}(46:90,:);
        gocue.earlyDF{k}=total(:,early_g); 
        gocue.lateDF{k}=total(:,late_g); 
        gocue.earlyZ{k}=(gocue.earlyDF{k}-mean(gocue.earlyDF{k}(1:15,:)))./std(gocue.earlyDF{k}(1:15,:));
        gocue.lateZ{k}=(gocue.lateDF{k}-mean(gocue.lateDF{k}(1:15,:)))./std(gocue.lateDF{k}(1:15,:));
     
        k=k+1;
    end
    clearvars -except gocue k jj file
end
clearvars -except gocue

for ii=1:549
    y1=gocue.earlyZ{ii}(16:45,:);%early
    y2=gocue.lateZ{ii}(16:45,:);%late
    value.index(ii,:)=cellidentify(y1,y2,2,2);
end
value.cell=find(value.index==1);
save('uncertain_valuecell_identify','gocue','value')


