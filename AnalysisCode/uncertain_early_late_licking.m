%% early/late trial,neron reponse onset
clear
file=dir('ACC*uncertain*.mat');
earlylick=[]; latelick=[];
k1=1;k2=1;
for jj=1:length(file)
    load(file(jj).name)
    totalevent=sort([Events.C1S3;Events.C1S5;Events.C1S12]); 
    hit=find(outcome(:,1)==1);
    for i=1:length(hit)
        cuetime=totalevent(hit(i),1);
        tp=find(Events.IN1>=cuetime & Events.IN1<=cuetime+1000);
        if ~isempty(tp)
            Lspoint(i,:)=(Events.IN1(tp(1))-cuetime)/1000;
        else
            Lspoint(i,:)=1;%if no anticipitory licks,lick latency set to 1s
        end
    end
    stimulusframe=totalevent(hit,1);
     Q1 = prctile (Lspoint,25);
     Q2 = prctile (Lspoint,75);
     early_trial=find(Lspoint<=Q1);
     late_trial=find(Lspoint>=Q2);
     n1=size(early_trial);
     n2=size(late_trial);
     p1=[];p2=[];
     for i=1:Info.Cellnumber   
          hitDF=eachDF{i}(:,hit);
        b1=hitDF(1:60,early_trial);
        s1=hitDF(61:93,early_trial);
      for j=1:n1
          for jk=1:30
             p1(j,jk)=ranksum(b1(:,j),s1(jk:jk+3,j));
          end
          sp=find(p1(j,:)<0.01);
          if ~isempty(sp)
              neuron_oneset.early(k1,1)=sp(1)/30;
              k1=k1+1;
          end
      end
        b2=hitDF(1:60,late_trial);
        s2=hitDF(61:93,late_trial);
      for j=1:n2
          for jk=1:30
             p2(j,jk)=ranksum(b2(:,j),s2(jk:jk+3,j));
          end
          sp=find(p2(j,:)<0.01);
          if ~isempty(sp)
              neuron_oneset.late(k2,1)=sp(1)/30;
              k2=k2+1;
          end
      end
     end
     clearvars -except  neuron_oneset k1 k2 jj file
end
%% early/late lick trial response
clearvars -except neuron_oneset
file=dir('ACC*uncertain*.mat');
k=1;
earlylick=[]; latelick=[];earlylicktimes=[];latelicktimes=[];
for jj=1:6
    load(file(jj).name)
    totalevent=sort([Events.C1S3;Events.C1S5;Events.C1S12]); 
    hit=find(outcome(:,1)==1);
    licktimes=[];
     for i=1:length(hit)
         cuetime=totalevent(hit(i),1);
         tp=find(Events.IN1>=cuetime & Events.IN1<=cuetime+1000);
        if ~isempty(tp)
            Lspoint(i,:)=(Events.IN1(tp(1))-cuetime)/1000;
            licktimes(i,:)=length(tp);
        else
            Lspoint(i,:)=1;licktimes(i,:)=0;%if no anticipitory licks,lick latency set to 1s
        end
     end
    Q1 = prctile (Lspoint,25);Q2 = prctile (Lspoint,75);
    early_trial=find(Lspoint<=Q1);
    late_trial=find(Lspoint>=Q2);
    earlylick=[earlylick;Lspoint(early_trial,:)];latelick=[latelick;Lspoint(late_trial,:)];
    earlylicktimes=[earlylicktimes;licktimes(early_trial,:)];latelicktimes=[latelicktimes;licktimes(late_trial,:)];
    for i=1:Info.Cellnumber
        hitDF=eachDF{i}(:,hit);
        hitZ=(hitDF-mean(hitDF(1:60,:)))./std(mean(hitDF(1:60,:)));
        earlyLDF{k}=hitDF(46:90,early_trial);
        lateLDF{k}=hitDF(46:90,late_trial);
        neuronresponse.meanZ(k,1)=mean(mean(hitZ(61:90,early_trial)));
        neuronresponse.meanZ(k,2)=mean(mean(hitZ(61:90,late_trial)));
        k=k+1;
    end
    clearvars -except k jj file earlyLDF lateLDF earlylick latelick earlylicktimes latelicktimes neuron_oneset neuronresponse
end
for i=1:549
    neuronresponse.early_DF(:,i)=mean(earlyLDF{i},2);
    neuronresponse.late_DF(:,i)=mean(lateLDF{i},2);
end
% norm
neuronresponse.early_z=(neuronresponse.early_DF-mean(neuronresponse.early_DF(1:15,:)))./std(neuronresponse.early_DF(1:15,:));
neuronresponse.late_z=(neuronresponse.late_DF-mean(neuronresponse.late_DF(1:15,:)))./std(neuronresponse.late_DF(1:15,:));
licklatency.early=earlylick;licklatency.late=latelick;
licktimes.early=earlylicktimes;licktimes.late=latelicktimes;
save('uncertain_early_late_lick','neuronresponse','neuron_oneset','licklatency','licktimes')
