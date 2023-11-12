%% stable/reverse/restable
clear
% file=dir('ACC*-stable*.mat');
file=dir('ACC*-restable*.mat');
% file=dir('ACC*-reverse*.mat');
nn=0;Cellid=[];
p=strfind(file(1).name,'-');
populationname=file(1).name(p(1)+1:p(2)-1);
k=1;
for j=1:length(file)
    load(file(j).name);
    label=str2num(file(j).name(4:5));
    cellid(:,2)=[1:Info.Cellnumber];
    cellid(:,1)=label;
    for jj=1:Info.Cellnumber
        hit=find(outcome(:,1)==1);miss=find(outcome(:,1)==2);
        cr=find(outcome(:,1)==3);fa=find(outcome(:,1)==4);
        population.goHit.eachDF{k}=eachDF{jj}(:,hit);
        population.goMiss.eachDF{k}=eachDF{jj}(:,miss);
        population.nogoCR.eachDF{k}=eachDF{jj}(:,cr);
        population.nogoFA.eachDF{k}=eachDF{jj}(:,fa);
        k=k+1;
    end
    Cellid=[Cellid;cellid];
    clear cellid
end
save(populationname,'population','Cellid');
%% uncertain
clear
file=dir('ACC*-uncertain*.mat');
nn=0;Cellid=[];
p=strfind(file(1).name,'-');
populationname=file(1).name(p(1)+1:p(2)-1);
k=1;
for j=1:length(file)
    load(file(j).name);
    label=str2num(file(j).name(4:5));
    cellid(:,2)=[1:Info.Cellnumber];
    cellid(:,1)=label;
    for jj=1:Info.Cellnumber
        hit=find(outcome(:,1)==1);miss=find(outcome(:,1)==2);
        cr=find(outcome(:,1)==3);fa=find(outcome(:,1)==4);
        ro=find(outcome(:,1)==5);ur=find(outcome(:,1)==6);
        population.goHit.eachDF{k}=eachDF{jj}(:,hit);
        population.goMiss.eachDF{k}=eachDF{jj}(:,miss);
        population.nogoCR.eachDF{k}=eachDF{jj}(:,cr);
        population.nogoFA.eachDF{k}=eachDF{jj}(:,fa);
        population.RO.eachDF{k}=eachDF{jj}(:,ro);
        population.UR.eachDF{k}=eachDF{jj}(:,ur);
        k=k+1;
    end
    Cellid=[Cellid;cellid];
    clear cellid
end
save(populationname,'population','Cellid');
%%
clear
load('stable.mat')
for i=1:length(Cellid)
    stable.Hit{i}=population.goHit.eachDF{i}(1:151,:)*100;
    stable.Miss{i}=population.goMiss.eachDF{i}(1:151,:)*100;
    stable.CR{i}=population.nogoCR.eachDF{i}(1:151,:)*100;
    stable.FA{i}=population.nogoFA.eachDF{i}(1:151,:)*100;
end
load('uncertain.mat')
for i=1:length(Cellid)
    uncertain.Hit{i}=population.goHit.eachDF{i}(1:151,:)*100;
    uncertain.Miss{i}=population.goMiss.eachDF{i}(1:151,:)*100;
    uncertain.CR{i}=population.nogoCR.eachDF{i}(1:151,:)*100;
    uncertain.FA{i}=population.nogoFA.eachDF{i}(1:151,:)*100;
    uncertain.RO{i}=population.RO.eachDF{i}(1:151,:)*100;
    uncertain.UR{i}=population.UR.eachDF{i}(1:151,:)*100;
end
load('reverse.mat')
for i=1:length(Cellid)
    reversal.Hit{i}=population.goHit.eachDF{i}(1:151,:)*100;
    reversal.Miss{i}=population.goMiss.eachDF{i}(1:151,:)*100;
    reversal.CR{i}=population.nogoCR.eachDF{i}(1:151,:)*100;
    reversal.FA{i}=population.nogoFA.eachDF{i}(1:151,:)*100;
end
load('restable.mat')
for i=1:length(Cellid)
    restable.Hit{i}=population.goHit.eachDF{i}(1:151,:)*100;
    restable.Miss{i}=population.goMiss.eachDF{i}(1:151,:)*100;
    restable.CR{i}=population.nogoCR.eachDF{i}(1:151,:)*100;
    restable.FA{i}=population.nogoFA.eachDF{i}(1:151,:)*100;
end
save('totalpopulation','stable','uncertain','reversal','restable')
