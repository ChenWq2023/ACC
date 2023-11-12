clear
Stim_sort=[]; Lick_sort=[];
k=1;
file=dir('ACC*stable*.mat');
for jj=1:length(file)
    load(file(jj).name)
    totalevent=sort([Events.C1S3;Events.C1S5]); 
    hit=find(outcome(:,1)==1);
     for i=1:length(hit)
         cuetime=totalevent(hit(i),1);
         tp=find(Events.IN1>=cuetime & Events.IN1<=cuetime+3000);
         licktime(i,:)=(Events.IN1(tp(1))-cuetime)/1000;
         licktimeframe(i,:)=round(licktime(i,:)*30)+60;
     end

    for i=1:Info.Cellnumber
        hitDF=eachDF{i}(:,hit);
        for ii=1:length(hit)
            stimDF{i}(:,ii)= hitDF(46:90,ii);
            firstlicksortDF{i}(:,ii)= hitDF(licktimeframe-14:licktimeframe+30,ii);
        end
        Stim_sort{k}=stimDF{i};
        Lick_sort{k}=firstlicksortDF{i};
        k=k+1;
    end
    clearvars -except file Stim_sort Lick_sort k
end
clearvars -except file Stim_sort Lick_sort 
load('stable.mat') ;
k1=1;k2=1;k3=1;k4=1;k5=1;k6=1;
for i=1:549
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
save('stim_lick_align','Stim_sort','Lick_sort','stable')