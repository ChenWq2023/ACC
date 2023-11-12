clear
stable=load('stable.mat') ;uncertain=load('uncertain.mat') ;reverse=load('reverse.mat') ;restable=load('restable.mat') ;
for i=1:493
    go=[stable.population.goHit.eachDF{i} stable.population.goMiss.eachDF{i}];%cue resposne time
    Sgo{i}=(go-mean(go(1:60,:)))./std(go(1:60,:));
    goR.stableZ(i,:)=mean(mean(Sgo{i}(61:90,:),2,'omitnan'));
    nogo=[stable.population.nogoCR.eachDF{i} stable.population.nogoFA.eachDF{i}];
    Snogo{i}=(nogo-mean(nogo(1:60,:)))./std(nogo(1:60,:));
    nogoR.stableZ(i,:)=mean(mean(Snogo{i}(61:90,:),2,'omitnan'));
    
    go=[uncertain.population.goHit.eachDF{i} uncertain.population.goMiss.eachDF{i} uncertain.population.RO.eachDF{i}];
    Ugo{i}=(go-mean(go(1:60,:)))./std(go(1:60,:));
    goR.uncertainZ(i,:)=mean(mean(Ugo{i}(61:90,:),2,'omitnan'));
    nogo=[uncertain.population.nogoCR.eachDF{i} uncertain.population.nogoFA.eachDF{i}];
    Unogo{i}=(nogo-mean(nogo(1:60,:)))./std(nogo(1:60,:));
    nogoR.uncertainZ(i,:)=mean(mean(Unogo{i}(61:90,:),2,'omitnan'));
    
    go=[reverse.population.goHit.eachDF{i} reverse.population.goMiss.eachDF{i}];
    Rgo{i}=(go-mean(go(1:60,:)))./std(go(1:60,:));
    goR.reverseZ(i,:)=mean(mean(Rgo{i}(61:90,:),2,'omitnan'));
    nogo=[reverse.population.nogoCR.eachDF{i} reverse.population.nogoFA.eachDF{i}];
    Rnogo{i}=(nogo-mean(nogo(1:60,:)))./std(nogo(1:60,:));
    nogoR.reverseZ(i,:)=mean(mean(Rnogo{i}(61:90,:),2,'omitnan'));
    
    go=[restable.population.goHit.eachDF{i} restable.population.goMiss.eachDF{i}];
    RSgo{i}=(go-mean(go(1:60,:)))./std(go(1:60,:));
    goR.restableZ(i,:)=mean(mean(RSgo{i}(61:90,:),2,'omitnan'));
    nogo=[restable.population.nogoCR.eachDF{i} restable.population.nogoFA.eachDF{i}];
    RSnogo{i}=(nogo-mean(nogo(1:60,:)))./std(nogo(1:60,:));
    nogoR.restableZ(i,:)=mean(mean(RSnogo{i}(61:90,:),2,'omitnan'));
end
nor=[goR.stableZ nogoR.stableZ goR.uncertainZ nogoR.uncertainZ goR.reverseZ nogoR.reverseZ goR.restableZ nogoR.restableZ];
gomean=[goR.stableZ goR.uncertainZ goR.reverseZ goR.restableZ];
nogomean=[nogoR.stableZ nogoR.uncertainZ nogoR.reverseZ nogoR.restableZ];

[p,tbl,stats] = friedman(nor(:,1:2:7),1,'off');
c1 = multcompare(stats,'CType','bonferroni');
[p,tbl,stats] =  friedman(nor(:,2:2:8),1,'off');
c2 = multcompare(stats,'CType','bonferroni');
[t,tb1,stats]=signrank(nor(:,1),nor(:,2));
[t,tb1,stats]=signrank(nor(:,3),nor(:,4));
[t,tb1,stats]=signrank(nor(:,5),nor(:,6));
[t,tb1,stats]=signrank(nor(:,7),nor(:,8));
save('cuemeanresponse','goR','nogoR','nor')
