clear
file=dir('ACC*restable*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
    n=length(outcome);
    n1=fix(n*0.33);n2=fix(n*0.67);
    go{1}=[find(outcome(1:n1,1)==1);find(outcome(1:n1,1)==2)];
    go{2}=[find(outcome(n1+1:n2,1)==1);find(outcome(n1+1:n2,1)==2)]+n1;
    go{3}=[find(outcome(n2+1:end,1)==1);find(outcome(n2+1:end,1)==2)]+n2;
    nogo{1}=[find(outcome(1:n1,1)==3);find(outcome(1:n1,1)==4)];
    nogo{2}=[find(outcome(n1+1:n2,1)==3);find(outcome(n1+1:n2,1)==4)]+n1;
    nogo{3}=[find(outcome(n2+1:end,1)==3);find(outcome(n2+1:end,1)==4)]+n2;
    for i=1:Info.Cellnumber
       total=eachDF{1, i};
        for ik=1:3
            restable.go{ik}{k}=total(:,go{ik});
            restable.goZ{ik}{k}=(restable.go{ik}{k}-mean(restable.go{ik}{k}(1:60,:)))./std(restable.go{ik}{k}(1:60,:));
            restable.nogo{ik}{k}=total(:,nogo{ik});
            restable.nogoZ{ik}{k}=(restable.nogo{ik}{k}-mean(restable.nogo{ik}{k}(1:60,:)))./std(restable.nogo{ik}{k}(1:60,:));
        end
        k=k+1;
    end
    clearvars -except restable k jj file
end
for i=1:493
    gomean(i,1)=mean(mean(restable.goZ{1}{i}(61:90,:)),'omitnan');
    gomean(i,2)=mean(mean(restable.goZ{2}{i}(61:90,:)),'omitnan');
    gomean(i,3)=mean(mean(restable.goZ{3}{i}(61:90,:)),'omitnan');
    nogomean(i,1)=mean(mean(restable.nogoZ{1}{i}(61:90,:)),'omitnan');
    nogomean(i,2)=mean(mean(restable.nogoZ{2}{i}(61:90,:)),'omitnan');
    nogomean(i,3)=mean(mean(restable.nogoZ{3}{i}(61:90,:)),'omitnan');
end
[t,tb1,stats]=friedman(gomean,1,'off');
c1 = multcompare(stats,'CType','bonferroni','Display','off');
[t,tb1,stats]=friedman(nogomean,1,'off');
c2 = multcompare(stats,'CType','bonferroni','Display','off');

save('restable_3phase_response','restable','gomean','nogomean')

clear
file=dir('ACC*stable*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
    n=length(outcome);
    n1=fix(n*0.33);n2=fix(n*0.67);
    go{1}=[find(outcome(1:n1,1)==1);find(outcome(1:n1,1)==2)];
    go{2}=[find(outcome(n1+1:n2,1)==1);find(outcome(n1+1:n2,1)==2)]+n1;
    go{3}=[find(outcome(n2+1:n,1)==1);find(outcome(n2+1:n,1)==2)]+n2;
    nogo{1}=[find(outcome(1:n1,1)==3);find(outcome(1:n1,1)==4)];
    nogo{2}=[find(outcome(n1+1:n2,1)==3);find(outcome(n1+1:n2,1)==4)]+n1;
    nogo{3}=[find(outcome(n2+1:end,1)==3);find(outcome(n2+1:end,1)==4)]+n2;
    for i=1:Info.Cellnumber
       total=eachDF{1, i};
        for ik=1:3
            stable.go{ik}{k}=total(:,go{ik});
            stable.goZ{ik}{k}=(stable.go{ik}{k}-mean(stable.go{ik}{k}(1:60,:)))./std(stable.go{ik}{k}(1:60,:));
            stable.nogo{ik}{k}=total(:,nogo{ik});
           stable.nogoZ{ik}{k}=(stable.nogo{ik}{k}-mean(stable.nogo{ik}{k}(1:60,:)))./std(stable.nogo{ik}{k}(1:60,:));
        end
        k=k+1;
    end
    clearvars -except stable k jj file
end
for i=1:493
    gomean(i,1)=mean(mean(stable.goZ{1}{i}(61:90,:)),'omitnan');
    gomean(i,2)=mean(mean(stable.goZ{2}{i}(61:90,:)),'omitnan');
    gomean(i,3)=mean(mean(stable.goZ{3}{i}(61:90,:)),'omitnan');
    nogomean(i,1)=mean(mean(stable.nogoZ{1}{i}(61:90,:)),'omitnan');
    nogomean(i,2)=mean(mean(stable.nogoZ{2}{i}(61:90,:)),'omitnan');
    nogomean(i,3)=mean(mean(stable.nogoZ{3}{i}(61:90,:)),'omitnan');
end
[t,tb1,stats]=friedman(gomean,1,'off');
c1 = multcompare(stats,'CType','bonferroni','Display','off');
[t,tb1,stats]=friedman(nogomean,1,'off');
c2 = multcompare(stats,'CType','bonferroni','Display','off');

save('stable_3phase_response','stable','gomean','nogomean')