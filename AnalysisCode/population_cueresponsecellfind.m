clear
load('stable.mat') ;
k1=1;k2=1;k3=1;k4=1;k5=1;k6=1;
for i=1:493
    stable.go{i}=[population.goHit.eachDF{i}(1:90,:) population.goMiss.eachDF{i}(1:90,:)];%cue resposne time
    stable.go{i}(:,find(isnan(stable.go{i}(1,:))))=[];
    stable.nogo{i}=[population.nogoCR.eachDF{i}(1:90,:) population.nogoFA.eachDF{i}(1:90,:)];
    stable.nogo{i}(:,find(isnan(stable.nogo{i}(1,:))))=[];
    b1=mean(stable.go{i}(1:60,:));
    b2=mean(stable.go{i}(61:90,:));
    b3=mean(stable.nogo{i}(1:60,:));
    b4=mean(stable.nogo{i}(61:90,:));
    p1(i,:)=signrank(b1,b2);
    p2(i,:)=signrank(b3,b4);
    if p1(i,:)<0.05 && mean(b2)>0
        stable.gocell{1}(k1,1)=i;%excite
        k1=k1+1;
    elseif p1(i,:)<0.05 && mean(b2)<0
        stable.gocell{2}(k2,1)=i;%inhibite
        k2=k2+1;
   elseif p1(i,:)>0.05
     stable.gocell{3}(k3,1)=i;
     k3=k3+1;
  end
  if p2(i,:)<0.05 && mean(b4)>0
     stable.nogocell{1}(k4,1)=i;
     k4=k4+1;
  elseif p2(i,:)<0.05 && mean(b4)<0
     stable.nogocell{2}(k5,1)=i;
     k5=k5+1; 
  elseif p2(i,:)>0.05
     stable.nogocell{3}(k6,1)=i;
     k6=k6+1; 
  end
  stable.gop=p1;
  stable.nogop=p2;
end
clearvars -except stable
load('uncertain.mat')
k1=1;k2=1;k3=1;k4=1;k5=1;k6=1;
for i=1:493 
  uncertain.go{i}=[population.goHit.eachDF{i}(1:90,:) population.goMiss.eachDF{i}(1:90,:) population.RO.eachDF{i}(1:90,:)]; 
  uncertain.go{i}(:,find(isnan(uncertain.go{i}(1,:))))=[];
  uncertain.nogo{i}=[population.nogoCR.eachDF{i}(1:90,:) population.nogoFA.eachDF{i}(1:90,:)]; 
  uncertain.nogo{i}(:,find(isnan(uncertain.nogo{i}(1,:))))=[];
  b1=mean(uncertain.go{i}(1:60,:));
  b2=mean(uncertain.go{i}(61:90,:));
  b3=mean(uncertain.nogo{i}(1:60,:));
  b4=mean(uncertain.nogo{i}(61:90,:));
  p1(i,:)=signrank(b1,b2);
  p2(i,:)=signrank(b3,b4);
  if p1(i,:)<0.05 && mean(b2)>0
     uncertain.gocell{1}(k1,1)=i;%excite
     k1=k1+1;
  elseif p1(i,:)<0.05 && mean(b2)<0
     uncertain.gocell{2}(k2,1)=i;%inhibite
     k2=k2+1;
   elseif p1(i,:)>0.05
     uncertain.gocell{3}(k3,1)=i;
     k3=k3+1;
  end
  if p2(i,:)<0.05 && mean(b4)>0
     uncertain.nogocell{1}(k4,1)=i;
     k4=k4+1;
  elseif p2(i,:)<0.05 && mean(b4)<0
     uncertain.nogocell{2}(k5,1)=i;
     k5=k5+1; 
  elseif p2(i,:)>0.05
     uncertain.nogocell{3}(k6,1)=i;
     k6=k6+1; 
  end
  uncertain.gop=p1;
  uncertain.nogop=p2;
end
clearvars -except stable uncertain
load('reverse.mat')
k1=1;k2=1;k3=1;k4=1;k5=1;k6=1;
for i=1:493
  reverse.go{i}=[population.goHit.eachDF{i}(1:90,:) population.goMiss.eachDF{i}(1:90,:)]; 
  reverse.go{i}(:,find(isnan(reverse.go{i}(1,:))))=[];
  reverse.nogo{i}=[population.nogoCR.eachDF{i}(1:90,:) population.nogoFA.eachDF{i}(1:90,:)]; 
  reverse.nogo{i}(:,find(isnan(reverse.nogo{i}(1,:))))=[];
  b1=mean(reverse.go{i}(1:60,:));
  b2=mean(reverse.go{i}(61:90,:));
  b3=mean(reverse.nogo{i}(1:60,:));
  b4=mean(reverse.nogo{i}(61:90,:));
  p1(i,:)=signrank(b1,b2);
  p2(i,:)=signrank(b3,b4);
  if p1(i,:)<0.05 && mean(b2)>0
     reverse.gocell{1}(k1,1)=i;%excite
     k1=k1+1;
  elseif p1(i,:)<0.05 && mean(b2)<0
     reverse.gocell{2}(k2,1)=i;%inhibite
     k2=k2+1;
   elseif p1(i,:)>0.05
     reverse.gocell{3}(k3,1)=i;
     k3=k3+1;
  end
  if p2(i,:)<0.05 && mean(b4)>0
     reverse.nogocell{1}(k4,1)=i;
     k4=k4+1;
  elseif p2(i,:)<0.05 && mean(b4)<0
     reverse.nogocell{2}(k5,1)=i;
     k5=k5+1; 
  elseif p2(i,:)>0.05
     reverse.nogocell{3}(k6,1)=i;
     k6=k6+1; 
  end
  reverse.gop=p1;
  reverse.nogop=p2;
end
clearvars -except stable uncertain  reverse
load('restable.mat')
k1=1;k2=1;k3=1;k4=1;k5=1;k6=1;
for i=1:493
  restabel.go{i}=[population.goHit.eachDF{i}(1:90,:) population.goMiss.eachDF{i}(1:90,:)]; 
  restabel.go{i}(:,find(isnan(restabel.go{i}(1,:))))=[];
  restabel.nogo{i}=[population.nogoCR.eachDF{i}(1:90,:) population.nogoFA.eachDF{i}(1:90,:)]; 
  restabel.nogo{i}(:,find(isnan(restabel.nogo{i}(1,:))))=[];
  b1=mean(restabel.go{i}(1:60,:));
  b2=mean(restabel.go{i}(61:90,:));
  b3=mean(restabel.nogo{i}(1:60,:));
  b4=mean(restabel.nogo{i}(61:90,:));
  p1(i,:)=signrank(b1,b2);
  p2(i,:)=signrank(b3,b4);
  if p1(i,:)<0.05 && mean(b2)>0
     restabel.gocell{1}(k1,1)=i;%excite
     k1=k1+1;
  elseif p1(i,:)<0.05 && mean(b2)<0
     restabel.gocell{2}(k2,1)=i;%inhibite
     k2=k2+1;
   elseif p1(i,:)>0.05
     restabel.gocell{3}(k3,1)=i;
     k3=k3+1;
  end
  if p2(i,:)<0.05 && mean(b4)>0
     restabel.nogocell{1}(k4,1)=i;
     k4=k4+1;
  elseif p2(i,:)<0.05 && mean(b4)<0
     restabel.nogocell{2}(k5,1)=i;
     k5=k5+1; 
  elseif p2(i,:)>0.05
     restabel.nogocell{3}(k6,1)=i;
     k6=k6+1; 
  end
  restabel.gop=p1;
  restabel.nogop=p2;
end
clearvars -except stable uncertain  reverse restabel
for i=1:3
    stablecell(i,:)=[length(stable.gocell{i}) length(stable.nogocell{i})];
    uncertaincell(i,:)=[length(uncertain.gocell{i}) length(uncertain.nogocell{i})];
    reversecell(i,:)=[length(reverse.gocell{i}) length(reverse.nogocell{i})];
    restablecell(i,:)=[length(restabel.gocell{i}) length(restabel.nogocell{i})];
end
responsecellnum=[stablecell uncertaincell reversecell restablecell];
gocell=responsecellnum(:,1:2:end);nogocell=responsecellnum(:,2:2:end);
save('cueresponsecell','responsecellnum','stable','uncertain','reverse','stable')
%chi2test
gocell=responsecellnum(:,1:2:end)';nogocell=responsecellnum(:,2:2:end)';
[p1(1), Q1(1)]= chi2test(gocell);
for i=2:4
    [p1(i), Q1(i)]= chi2test([gocell(1,:);gocell(i,:)]);
end
p1(2:4)=p1(2:4)*4;
[p2(1), Q2(1)]= chi2test(nogocell);
for i=2:4
    [p2(i), Q2(i)]= chi2test([nogocell(1,:);nogocell(i,:)]);
end
p2(2:4)=p2(2:4)*4;
for i=1:4
    [p3(i), Q3(i)]= chi2test([gocell(i,:);nogocell(i,:)]);
end
p3=p3*4;
