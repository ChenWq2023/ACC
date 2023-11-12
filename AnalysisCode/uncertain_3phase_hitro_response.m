clear
file=dir('ACC*uncertain*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
     n=length(outcome);
    n1=fix(n*0.33);n2=fix(n*0.67);
    trialnum_hit(1)=length(find(outcome(1:n1,1)==1));%count trial number
    trialnum_hit(2)=length(find(outcome(n1+1:n2,1)==1));
    trialnum_hit(3)=length(find(outcome(n2+1:end,1)==1));
    trialnum_ro(1)=length(find(outcome(1:n1,1)==5));
    trialnum_ro(2)=length(find(outcome(n1+1:n2,1)==5));
    trialnum_ro(3)=length(find(outcome(n2+1:end,1)==5));
    for i=1:Info.Cellnumber
        trial_index(k,:)=[trialnum_hit trialnum_ro];
        k=k+1;
    end
    clearvars -except trial_index k jj file
end
load('uncertain_outcomecell_identify.mat')
for i=1:549
    hittrial(i,1)=0;hittrial(i,2)=trial_index(i,1);hittrial(i,3)=hittrial(i,2)+trial_index(i,2);
    hittrial(i,4)=hittrial(i,3)+trial_index(i,3);
    rotrial(i,1)=0;rotrial(i,2)=trial_index(i,4);rotrial(i,3)=rotrial(i,2)+trial_index(i,5);
    rotrial(i,4)=rotrial(i,3)+trial_index(i,6);
    for j=1:3%T1~T3
        hidx=[hittrial(i,j)+1:hittrial(i,j+1)];
        ridx=[rotrial(i,j)+1:rotrial(i,j+1)];
        hitZ=reward.hitZ{i}(16:45,hidx);
        roZ=reward.roZ{i}(16:45,ridx); 
        HitZ(i,j)=mean(mean(hitZ));
        RoZ(i,j)=mean(mean(roZ));
    end
end
save('uncertain_hitro_3phase','HitZ','RoZ','trial_index')
