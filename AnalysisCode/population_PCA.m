clear
stable=load('stable.mat') ;uncertain=load('uncertain.mat') ;reverse=load('reverse.mat') ;restable=load('restable.mat') ;
for i=1:493
    go1=[stable.population.goHit.eachDF{i} stable.population.goMiss.eachDF{i}];
    go1=go1(46:90,:);Sgo{i}=(go1-mean(go1(1:15,:)))./std(go1(1:15,:));
    GO(1,i)=mean(mean(Sgo{i}(16:end,:),2,'omitnan'),'omitnan');
    go2=[uncertain.population.goHit.eachDF{i} uncertain.population.goMiss.eachDF{i} uncertain.population.RO.eachDF{i}];
    go2=go2(46:90,:);Ugo{i}=(go2-mean(go2(1:15,:)))./std(go2(1:15,:));
    GO(2,i)=mean(mean(Ugo{i}(16:end,:),2,'omitnan'),'omitnan');
    go3=[reverse.population.goHit.eachDF{i} reverse.population.goMiss.eachDF{i}];
    go3=go3(46:90,:);Rgo{i}=(go3-mean(go3(1:15,:)))./std(go3(1:15,:));
    GO(3,i)=mean(mean(Rgo{i}(16:end,:),2,'omitnan'),'omitnan');
    go4=[restable.population.goHit.eachDF{i} restable.population.goMiss.eachDF{i}];
    go4=go4(46:90,:);RSgo{i}=(go4-mean(go4(1:15,:)))./std(go4(1:15,:));
    GO(4,i)=mean(mean(RSgo{i}(16:end,:),2,'omitnan'),'omitnan');
   nogo1=[stable.population.nogoCR.eachDF{i} stable.population.nogoFA.eachDF{i}];
    nogo1=nogo1(46:90,:); Snogo{i}=(nogo1-mean(nogo1(1:15,:)))./std(nogo1(1:15,:));
    NOGO(1,i)=mean(mean(Snogo{i}(16:end,:),2,'omitnan'),'omitnan');
    nogo2=[uncertain.population.nogoCR.eachDF{i} uncertain.population.nogoFA.eachDF{i}];
    nogo2=nogo2(46:90,:);Unogo{i}=(nogo2-mean(nogo2(1:15,:)))./std(nogo2(1:15,:));
    NOGO(2,i)=mean(mean(Unogo{i}(16:end,:),2,'omitnan'),'omitnan');
    nogo3=[reverse.population.nogoCR.eachDF{i} reverse.population.nogoFA.eachDF{i}];
    nogo3=nogo3(46:90,:);Rnogo{i}=(nogo3-mean(nogo3(1:15,:)))./std(nogo3(1:15,:));
    NOGO(3,i)=mean(mean(Rnogo{i}(16:end,:),2,'omitnan'),'omitnan');
    nogo4=[restable.population.nogoCR.eachDF{i} restable.population.nogoFA.eachDF{i}];
    nogo4=nogo4(46:90,:); RSnogo{i}=(nogo4-mean(nogo4(1:15,:)))./std(nogo4(1:15,:));
    NOGO(4,i)=mean(mean(RSnogo{i}(16:end,:),2,'omitnan'),'omitnan'); 
end
totalresponsemean=[GO;NOGO];
[coeff,score,latent,tsquared,explained,mu]=pca(totalresponsemean);
save('populationPCA','totalresponsemean','score','explained')
