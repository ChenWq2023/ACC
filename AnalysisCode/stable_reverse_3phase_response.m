%%
clear
file=dir('ACC*reverse*.mat');
k=1;
for jj=1:length(file)
   load(file(jj).name)
    n=length(outcome);
    n1=fix(n*0.15);n2=fix(n*0.50);
    go{1}=[find(outcome(1:n1,1)==1);find(outcome(1:n1,1)==2)];
    go{2}=[find(outcome(n1+1:n2,1)==1);find(outcome(n1+1:n2,1)==2)]+n1;
    go{3}=[find(outcome(n2+1:end,1)==1);find(outcome(n2+1:end,1)==2)]+n2;
    nogo{1}=[find(outcome(1:n1,1)==3);find(outcome(1:n1,1)==4)];
    nogo{2}=[find(outcome(n1+1:n2,1)==3);find(outcome(n1+1:n2,1)==4)]+n1;
    nogo{3}=[find(outcome(n2+1:end,1)==3);find(outcome(n2+1:end,1)==4)]+n2;
    for i=1:Info.Cellnumber
       total=eachDF{1, i};
       totalz=(total-mean(total(1:60,:)))./std(total(1:60,:));
        for ik=1:3
            reverse.goZ{ik}{k}=totalz(61:90,go{ik});
            reverse.nogoZ{ik}{k}=totalz(61:90,nogo{ik});
        end
        k=k+1;
    end
    clearvars -except reverse k jj file
end
load('stable.mat')
for i=1:549
    st=[population.goHit.eachDF{i} population.goMiss.eachDF{i}];
    stz=(st-mean(st(1:60,:)))./std(st(1:60,:));
    stable.goZ{i}=stz(61:90,:);
    st=[population.nogoCR.eachDF{i} population.nogoFA.eachDF{i}];
    stz=(st-mean(st(1:60,:)))./std(st(1:60,:));
    stable.nogoZ{i}=stz(61:90,:);
end
for i=1:493
    T_3k_mean(i,1)=mean(mean(stable.goZ{i},'omitnan'));
    T_3k_mean(i,2)=mean(mean(reverse.nogoZ{1}{i},'omitnan'));
    T_3k_mean(i,3)=mean(mean(reverse.nogoZ{2}{i},'omitnan'));
    T_3k_mean(i,4)=mean(mean(reverse.nogoZ{3}{i},'omitnan'));
    T_12k_mean(i,1)=mean(mean(stable.nogoZ{i},'omitnan'));
    T_12k_mean(i,2)=mean(mean(reverse.goZ{1}{i},'omitnan'));
    T_12k_mean(i,3)=mean(mean(reverse.goZ{2}{i},'omitnan'));
    T_12k_mean(i,4)=mean(mean(reverse.goZ{3}{i},'omitnan'));
end

[t,tb1,stats]=friedman(T_3k_mean,1,'off');
c1 = multcompare(stats,'CType','bonferroni','Display','off');
[t,tb1,stats]=friedman(T_12k_mean,1,'off');
c2 = multcompare(stats,'CType','bonferroni','Display','off');
save('reverse_3phase_response','stable','reverse','T_3k_mean','T_12k_mean')
