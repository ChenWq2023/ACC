clear
file=dir('ACC*uncertain*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
    n=length(outcome);
    n1=fix(n*0.33);n2=fix(n*0.67);
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
            uncertain.goZ{ik}{k}=totalz(61:90,go{ik});
            uncertain.nogoZ{ik}{k}=totalz(61:90,nogo{ik});
        end
        k=k+1;
    end
    clearvars -except uncertain k jj file
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
for i=1:549
    gomean(i,1)=mean(mean(stable.goZ{i},'omitnan'));
    gomean(i,2)=mean(mean(uncertain.goZ{1}{i},'omitnan'));
    gomean(i,3)=mean(mean(uncertain.goZ{2}{i},'omitnan'));
    gomean(i,4)=mean(mean(uncertain.goZ{3}{i},'omitnan'));
    nogomean(i,1)=mean(mean(stable.nogoZ{i},'omitnan'));
    nogomean(i,2)=mean(mean(uncertain.nogoZ{1}{i},'omitnan'));
    nogomean(i,3)=mean(mean(uncertain.nogoZ{2}{i},'omitnan'));
    nogomean(i,4)=mean(mean(uncertain.nogoZ{3}{i},'omitnan'));
end
[t,tb1,stats]=friedman(gomean,1,'off');
c1 = multcompare(stats,'CType','bonferroni','Display','off');
[t,tb1,stats]=friedman(nogomean,1,'off');
c2 = multcompare(stats,'CType','bonferroni','Display','off');
save('uncertain_3phase_response','stable','uncertain','gomean','nogomean')
