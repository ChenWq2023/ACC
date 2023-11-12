clear
file=dir('ACC*uncertain*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
    hit=find(outcome(:,1)==1);
    rewardtime=outcome(hit,2)+60;
    N=Info.Cellnumber;
    for j=1:N
         for i=1:length(hit)
           reward.uncertain_hitDF{k}(:,i)=eachDF{j}(rewardtime(i)-14:rewardtime(i)+30,hit(i));
        end
        stim.uncertain_hitDF{k}=eachDF{j}(46:90,hit);
        k=k+1;
    end 
    clearvars -except file reward stim k
end

file=dir('ACC*stable*.mat');
k=1;
for jj=1:length(file)
     load(file(jj).name)
    hit=find(outcome(:,1)==1);
    rewardtime=outcome(hit,2)+60;
    N=Info.Cellnumber;
    for j=1:N
         for i=1:length(hit)
           reward.stable_hitDF{k}(:,i)=eachDF{j}(rewardtime(i)-14:rewardtime(i)+30,hit(i));
        end
        stim.stable_hitDF{k}=eachDF{j}(46:90,hit);
        k=k+1;
    end 
    clearvars -except file reward stim k
end
for i=1:549
   stim.stable(:,i)=mean(stim.stable_hitDF{i},2,'omitnan');
   stim.uncertain(:,i)=mean(stim.uncertain_hitDF{i},2,'omitnan');
   reward.stable(:,i)=mean(reward.stable_hitDF{i},2,'omitnan');
   reward.uncertain(:,i)=mean(reward.uncertain_hitDF{i},2,'omitnan');
end
stim.stableZ=(stim.stable-mean(stim.stable(1:15,:)))./std(stim.stable(1:15,:));
stim.uncertainZ=(stim.uncertain-mean(stim.uncertain(1:15,:)))./std(stim.uncertain(1:15,:));
reward.stableZ=(reward.stable-mean(reward.stable(1:15,:)))./std(reward.stable(1:15,:));
reward.uncertainZ=(reward.uncertain-mean(reward.uncertain(1:15,:)))./std(reward.uncertain(1:15,:));
save('stable_uncertain_Hit','stim','reward')
