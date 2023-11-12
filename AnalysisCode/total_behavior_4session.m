stable=nan(6,4);uncertain=nan(6,4);reverse=nan(5,4);restable=nan(5,4);
f1=dir('ACC*stable-DF.mat');
for i=1:length(f1)
    load(f1(i).name)
    stable(i,1)=Info.Hit;stable(i,2)=Info.Miss;stable(i,3)=Info.CR;stable(i,4)=Info.FA;
end
f2=dir('ACC*uncertain-DF.mat');
for i=1:length(f2)
    load(f2(i).name)
    uncertain(i,1)=Info.Hit+Info.RO;uncertain(i,2)=Info.Miss;uncertain(i,3)=Info.CR;uncertain(i,4)=Info.FA;
end
f3=dir('ACC*reverse-DF.mat');
for i=1:length(f3)
    load(f3(i).name)
    reverse(i,1)=Info.Hit;reverse(i,2)=Info.Miss;reverse(i,3)=Info.CR;reverse(i,4)=Info.FA;
end
f4=dir('ACC*restable-DF.mat');
for i=1:length(f4)
    load(f4(i).name)
    restable(i,1)=Info.Hit;restable(i,2)=Info.Miss;restable(i,3)=Info.CR;restable(i,4)=Info.FA;
end
total=[stable;uncertain;reverse;restable];
for i=1:length(total)
    h(i,1)=total(i,1)/(total(i,1)+total(i,2));
    f(i,1)=total(i,4)/(total(i,3)+total(i,4));
     if h(i,1)==1
         h(i,1)=1-1/(2*(total(i,1)+total(i,2)));
     end
      if h(i,1)==0
         h(i,1)=1/(2*(total(i,1)+total(i,2)));
     end
     if f(i,1)==0
        f(i,1)=1/(2*(total(i,3)+total(i,4)));
     end
     if f(i,1)==1
        f(i,1)=1-1/(2*(total(i,3)+total(i,4)));
     end
   d(i,:)=norminv(h(i,1)) - norminv(f(i,1));
end
Hit=total(:,1)./(total(:,1)+total(:,2))*100;
FA=total(:,4)./(total(:,3)+total(:,4))*100;
Stable_d=d(1:6,:);Uncertain_d=d(7:12,:);Reversal_d=[d(13:17,:);nan];Restable_d=[d(18:22,:);nan];
Stable_Hit=Hit(1:6,:);Uncertain_Hit=Hit(7:12,:);Reversal_Hit=[Hit(13:17,:);nan];Restable_Hit=[Hit(18:22,:);nan];
Stable_FA=FA(1:6,:);Uncertain_FA=FA(7:12,:);Reversal_FA=[FA(13:17,:);nan];Restable_FA=[FA(18:22,:);nan];
mice = {'ACC01';'ACC02';'ACC03';'ACC04';'ACC05';'ACC06';};
total_d = table(mice,Stable_d,Uncertain_d,Reversal_d,Restable_d);
total_Hit = table(mice,Stable_Hit,Uncertain_Hit,Reversal_Hit,Restable_Hit);
total_FA = table(mice,Stable_FA,Uncertain_FA,Reversal_FA,Restable_FA);
save('total_behavior','stable','uncertain','reverse','restable','total_d','total_Hit','total_FA')
