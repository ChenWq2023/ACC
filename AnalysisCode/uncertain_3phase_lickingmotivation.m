%% anticiptory lick
clear
file=dir('ACC*uncertain*.mat');
Licktrace.stim=cell(1,4);Licktrace.reward=cell(1,4);
Licktime.stim=cell(1,4);Licktime.reward=cell(1,4);
Licklatency=cell(1,4);
for jj=1:6
    load(file(jj).name)
    hit=find(outcome(:,1)==1 | outcome(:,1)==5);
    totalevent=sortrows([Events.C1S3;Events.C1S5;Events.C1S12]);
    n=length(outcome);
    n1=eventframe(fix(n*0.33));n2=eventframe(fix(n*0.67));
    stimulusframe=eventframe(hit,:);stimulustime=totalevent(hit,:);
    reward=find(outcome(:,1)==1 | outcome(:,1)==6);
    rewardframe=eventframe(reward,1)+outcome(reward,2);%reward time
    rewardframe(find(rewardframe+60>20000))=[];
    lickr=findFrameForEvent(Events.IN3,Events.IN1);%lick frame
    edge=[1:1:length(Events.IN3)];LR=histc(lickr,edge);
    Lspoint=[];
    for i=1:length(stimulusframe)
        licktrace_stim(:,i)=LR(stimulusframe(i):stimulusframe(i)+30,:);
         temp=find(Events.IN1>=stimulustime(i) & Events.IN1<=stimulustime(i)+1000);
        if ~isempty(temp)
            Lspoint(i)=(Events.IN1(temp(1))-stimulustime(i))/1000;
        else
             Lspoint(i)=1;
        end
    end
    for i=1:length(rewardframe)
        licktrace_reward(:,i)=LR(rewardframe(i)-30:rewardframe(i)+60,:);
    end
    
    S{1}=find(stimulusframe(:,1)<=n1);S{2}=find(stimulusframe(:,1)>n1 & stimulusframe(:,1)<n2);S{3}=find(stimulusframe(:,1)>=n2);
    R{1}=find(rewardframe(:,1)<=n1);R{2}=find(rewardframe(:,1)>n1 & rewardframe(:,1)<n2);R{3}=find(rewardframe(:,1)>=n2);
    for ik=1:3
        Licktrace.stim{ik+1}=[Licktrace.stim{ik+1} licktrace_stim(:,S{ik})];%uncertian
        Licktrace.reward{ik+1}=[Licktrace.reward{ik+1} licktrace_reward(:,R{ik})];
        Licktime.stim{ik+1}=[Licktime.stim{ik+1};sum(licktrace_stim(:,S{ik}))'];
        Licktime.reward{ik+1}=[Licktime.reward{ik+1};sum(licktrace_reward(31:90,R{ik}))'];
        Licklatency{ik+1}=[Licklatency{ik+1};Lspoint(:,S{ik})'];
        
    end
    clearvars -except jj file Licktrace Licktime  Licklatency
end

file=dir('ACC*stable*.mat');
for jj=1:6
    load(file(jj).name)
    totalevent=sortrows([Events.C1S3;Events.C1S5]);
    hit=find(outcome(:,1)==1);
    n=length(outcome);
    stimulusframe=eventframe(hit,:);stimulustime=totalevent(hit,:);
    rewardframe=findFrameForEvent(Events.IN3,Events.OUT1(:,1));
    rewardframe(find(rewardframe+60>20000))=[];rewardframe(isnan(rewardframe))=[];
    lickr=findFrameForEvent(Events.IN3,Events.IN1);%lick frame
    edge=[1:1:length(Events.IN3)];LR=histc(lickr,edge);
     Lspoint=[];
    for i=1:length(stimulusframe)
        licktrace_stim(:,i)=LR(stimulusframe(i):stimulusframe(i)+30,:);
        temp=find(Events.IN1>=stimulustime(i) & Events.IN1<=stimulustime(i)+1000);
        if ~isempty(temp)
            Lspoint(i)=(Events.IN1(temp(1))-stimulustime(i))/1000;
        else
             Lspoint(i)=1;
        end
        licktrace_reward(:,i)=LR(rewardframe(i)-30:rewardframe(i)+60,:);
    end
    Licktrace.stim{1}=[Licktrace.stim{1} licktrace_stim];
    Licktrace.reward{1}=[Licktrace.reward{1} licktrace_reward];
    Licktime.stim{1}=[Licktime.stim{1};sum(licktrace_stim)'];
    Licktime.reward{1}=[Licktime.reward{1};sum(licktrace_reward(31:90,:))'];
    Licklatency{1}=[Licklatency{1};Lspoint'];    
    clearvars -except jj file Licktrace Licktime  Licklatency
end
licktime_stim=nan(200,4);licklatency=nan(200,4);licktime_reward=nan(200,4);
for i=1:4
    Licktrace.stim{i}=zero_filter_lowpass(Licktrace.stim{i}*30,30,3);
    Licktrace.reward{i}=zero_filter_lowpass(Licktrace.reward{i}*30,30,3);
    Licktime.reward{i}(find(Licktime.reward{i}==0),:)=1;%at least once
    num1=length(Licktime.stim{i});
    num2=length(Licktime.reward{i});
    licktime_stim(1:num1,i)=Licktime.stim{i};licklatency(1:num1,i)=Licklatency{i};
    licktime_reward(1:num2,i)=Licktime.reward{i};
end
save('uncertain_lick_3phase','Licktime','Licktrace','Licklatency','licktime_stim','licktime_reward','licklatency')