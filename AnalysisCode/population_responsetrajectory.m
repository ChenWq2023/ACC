%% population trajectory
clear
load('stable.mat')
for i=1:493
    go=[population.goHit.eachDF{i}(46:90,:) population.goMiss.eachDF{i}(46:90,:)];%cue resposne time
    go=(go-mean(go(1:15,:)))./std(go(1:15,:));
    stable.goR(:,i)=mean(go,2,'omitnan');
    nogo=[population.nogoCR.eachDF{i}(46:90,:) population.nogoFA.eachDF{i}(46:90,:)];
    nogo=(nogo-mean(nogo(1:15,:)))./std(nogo(1:15,:));
    stable.nogoR(:,i)=mean(nogo,2,'omitnan');
end
[coeff,score,latent,tsquared,stable.explained1,~]=pca(stable.goR);
stable.PCA_go=score(:,1:3);
[coeff,score,latent,tsquared,stable.explained2,~]=pca(stable.nogoR);
stable.PCA_nogo=score(:,1:3);

load('uncertain.mat')
for i=1:493
    go=[population.goHit.eachDF{i}(46:90,:) population.goMiss.eachDF{i}(46:90,:)  population.RO.eachDF{i}(46:90,:)];
    go=(go-mean(go(1:15,:)))./std(go(1:15,:));
    uncertain.goR(:,i)=mean(go,2,'omitnan');
    nogo=[population.nogoCR.eachDF{i}(46:90,:) population.nogoFA.eachDF{i}(46:90,:)];
    nogo=(nogo-mean(nogo(1:15,:)))./std(nogo(1:15,:));
    uncertain.nogoR(:,i)=mean(nogo,2,'omitnan');
end
[coeff,score,latent,tsquared,uncertain.explained1,~]=pca(uncertain.goR);
uncertain.PCA_go=score(:,1:3);
[coeff,score,latent,tsquared,uncertain.explained2,~]=pca(uncertain.nogoR);
uncertain.PCA_nogo=score(:,1:3);

load('reverse.mat')
for i=1:493
    go=[population.goHit.eachDF{i}(46:90,:) population.goMiss.eachDF{i}(46:90,:)];
    go=(go-mean(go(1:15,:)))./std(go(1:15,:));
    reverse.goR(:,i)=mean(go,2,'omitnan');
    nogo=[population.nogoCR.eachDF{i}(46:90,:) population.nogoFA.eachDF{i}(46:90,:)];
    nogo=(nogo-mean(nogo(1:15,:)))./std(nogo(1:15,:));
    reverse.nogoR(:,i)=mean(nogo,2,'omitnan');
end
[coeff,score,latent,tsquared,reverse.explained1,~]=pca(reverse.goR);
reverse.PCA_go=score(:,1:3);
[coeff,score,latent,tsquared,reverse.explained2,~]=pca(reverse.nogoR);
reverse.PCA_nogo=score(:,1:3);

load('restable.mat')
for i=1:493
    go=[population.goHit.eachDF{i}(46:90,:) population.goMiss.eachDF{i}(46:90,:)];
    go=(go-mean(go(1:15,:)))./std(go(1:15,:));
    restable.goR(:,i)=mean(go,2,'omitnan');
    nogo=[population.nogoCR.eachDF{i}(46:90,:) population.nogoFA.eachDF{i}(46:90,:)];
    nogo=(nogo-mean(nogo(1:15,:)))./std(nogo(1:15,:));
    restable.nogoR(:,i)=mean(nogo,2,'omitnan');
end
[coeff,score,latent,tsquared,restable.explained1,~]=pca(restable.goR);
restable.PCA_go=score(:,1:3);
[coeff,score,latent,tsquared,restable.explained2,~]=pca(restable.nogoR);
restable.PCA_nogo=score(:,1:3);
save('responsetrajectory','stable','uncertain','reverse','restable')
%% BOOTSTRAP go cue-nogocue distance
%Note that the boorstrap result not exactly the same form run to run
load('responsetrajectory.mat')
cellid=[1:493];%cell label
for sh=1:5000 %5000 times bootstrap
    c=randsample(cellid,40);
    [~,score1,~,~,explained1,~]=pca(stable.goR(:,c));
    [~,score2,~,~,explained2,~]=pca(stable.nogoR(:,c));
    E1=cumsum(explained1);
    E2=cumsum(explained2);
    n=3;%pc1-3
    PCA_a1=score1(:,1:n);
    PCA_b1=score2(:,1:n);
    [~,score1,~,~,explained1,~]=pca(uncertain.goR(:,c));
    [~,score2,~,~,explained2,~]=pca(uncertain.nogoR(:,c));

    PCA_a2=score1(:,1:n);
    PCA_b2=score2(:,1:n);
    [~,score1,~,~,explained1,~]=pca(reverse.goR(:,c));
   [~,score2,~,~,explained2,~]=pca(reverse.nogoR(:,c));
    PCA_a3=score1(:,1:n);
    PCA_b3=score2(:,1:n);
    [~,score1,~,~,explained1,~]=pca(restable.goR(:,c));
    [~,score2,~,~,explained2,~]=pca(restable.nogoR(:,c));

    PCA_a4=score1(:,1:n);
    PCA_b4=score2(:,1:n);
    go=zeros(45,4);
    nogo=zeros(45,4);
    gonogodistance=zeros(45,4);
    for i = 1:45
        gonogodistance(i,1)=distn(PCA_a1(i,:),PCA_b1(i,:));
        gonogodistance(i,2)=distn(PCA_a2(i,:),PCA_b2(i,:));
        gonogodistance(i,3)=distn(PCA_a3(i,:),PCA_b3(i,:));
        gonogodistance(i,4)=distn(PCA_a4(i,:),PCA_b4(i,:));
        if i>1
        go(i,1)=distn(PCA_a1(i,:),PCA_a1(i-1,:));
        go(i,2)=distn(PCA_a2(i,:),PCA_a2(i-1,:));
        go(i,3)=distn(PCA_a3(i,:),PCA_a3(i-1,:));
        go(i,4)=distn(PCA_a4(i,:),PCA_a4(i-1,:));
        nogo(i,1)=distn(PCA_b1(i,:),PCA_b1(i-1,:));
        nogo(i,2)=distn(PCA_b2(i,:),PCA_b2(i-1,:));
        nogo(i,3)=distn(PCA_b3(i,:),PCA_b3(i-1,:));
        nogo(i,4)=distn(PCA_b4(i,:),PCA_b4(i-1,:));
        end
    end
    D(sh,:)=sum(gonogodistance(16:end,:));%sum go/nogo distence
    dgo(sh,:)=sum(go(16:end,:));%sum go length
    dnogo(sh,:)=sum(nogo(16:end,:));%sum nogo length
end
cuelength=[dgo(:,1) dnogo(:,1) dgo(:,2) dnogo(:,2) dgo(:,3) dnogo(:,3) dgo(:,4) dnogo(:,4)];
save('responsetrajectory_bootstrap','D','dgo','dnogo','cuelength')
[p,tbl,stats] = kruskalwallis(D,[],'off')
c = multcompare(stats,'CType','bonferroni','Display','off')
[p,tbl,stats] = kruskalwallis(dgo,[],'off')
c1 = multcompare(stats,'CType','bonferroni','Display','off')
[p,tbl,stats] = kruskalwallis(dnogo,[],'off')
c2 = multcompare(stats,'CType','bonferroni','Display','off')
[p,h,stats] = ranksum(cuelength(:,1),cuelength(:,2))
[p,h,stats] = ranksum(cuelength(:,3),cuelength(:,4))
[p,h,stats] = ranksum(cuelength(:,5),cuelength(:,6))
[p,h,stats] = ranksum(cuelength(:,7),cuelength(:,8))