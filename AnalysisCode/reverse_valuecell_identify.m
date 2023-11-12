clear
file=dir('ACC*reverse*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
    n=length(outcome);
    n1=fix(n*0.15);
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

for ii=1:493
    y1=nogocue.earlyZ{ii}(16:45,:);%early
    y2=nogocue.lateZ{ii}(16:45,:);%last
    value.index(ii,:)=cellidentify(y1,y2,2,2);
end
value.cell=find(value.index==1);
save('reverse_valuecell_identify','nogocue','value')