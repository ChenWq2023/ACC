%%
clear
file=dir('ACC*restable*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
    n=length(outcome);
    n1=fix(n*0.15);n2=fix(n*0.5);
    go{1}=[find(outcome(1:n1,1)==1);find(outcome(1:n1,1)==2);find(outcome(1:n1,1)==5)];
    go{2}=[find(outcome(n1+1:n2,1)==1);find(outcome(n1+1:n2,1)==2);find(outcome(n1+1:n2,1)==5)]+n1;
    go{3}=[find(outcome(n2+1:end,1)==1);find(outcome(n2+1:end,1)==2);find(outcome(n2+1:end,1)==5)]+n2;
    nogo{1}=[find(outcome(1:n1,1)==3);find(outcome(1:n1,1)==4)];
    nogo{2}=[find(outcome(n1+1:n2,1)==3);find(outcome(n1+1:n2,1)==4)]+n1;
    nogo{3}=[find(outcome(n2+1:end,1)==3);find(outcome(n2+1:end,1)==4)]+n2;
    for i=1:Info.Cellnumber
        total=eachDF{1, i};
        totalz=(total-mean(total(1:60,:)))./std(total(1:60,:));
        for ik=1:3
            restable.goZ{ik}{k}=totalz(:,go{ik});
            restable.nogoZ{ik}{k}=totalz(:,nogo{ik});
        end
        k=k+1;
    end
    clearvars -except restable k jj file
end
for i=1:493
    T_3k_mean(i,1)=mean(mean(restable.nogoZ{1}{i},'omitnan'));
    T_3k_mean(i,2)=mean(mean(restable.nogoZ{2}{i},'omitnan'));
    T_3k_mean(i,3)=mean(mean(restable.nogoZ{3}{i},'omitnan'));
end
save('restable_3phase_15_T3response','T_3k_mean')