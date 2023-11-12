clear
file=dir('ACC*uncertain*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
    N=Info.Cellnumber;
    hit=find(outcome(:,1)==1);
    ro=find(outcome(:,1)==5);
    ur=find(outcome(:,1)==6);
    for j=1:N
        hitdf=eachDF{j}(:,hit);
        rodf=eachDF{j}(:,ro);
        urdf=eachDF{j}(:,ur);
        for i=1:length(hit)
            rewardtime=outcome(hit,2)+60;%60f baseline
            reward.hitDF{k}(:,i)=hitdf(rewardtime(i)-14:rewardtime(i)+30,i);
            
        end
        reward.hitZ{k}=(reward.hitDF{k}-mean(reward.hitDF{k}(1:15,:)))./std(reward.hitDF{k}(1:15,:));
        for i=1:length(ro)
            rewardtime=outcome(ro,2)+60;
            reward.roDF{k}(:,i)=rodf(rewardtime(i)-14:rewardtime(i)+30,i);
        end
        reward.roZ{k}=(reward.roDF{k}-mean(reward.roDF{k}(1:15,:)))./std(reward.roDF{k}(1:15,:));
        for i=1:length(ur)
            rewardtime=outcome(ur,2)+60;
            reward.urDF{k}(:,i)=urdf(rewardtime(i)-14:rewardtime(i)+30,i);
        end
        reward.urZ{k}=(reward.urDF{k}-mean(reward.urDF{k}(1:15,:)))./std(reward.urDF{k}(1:15,:));
        
     k=k+1;  
    end
end

clearvars -except reward
for ii=1:549
    y1=reward.roZ{ii}(16:45,:);
    y2=reward.hitZ{ii}(16:45,:);
    outcome.index(ii,:)=cellidentify(y1,y2,2,2);
end
 outcome.cell=find(outcome.index==1);
 save('uncertain_outcomecell_identify','reward','outcome')
