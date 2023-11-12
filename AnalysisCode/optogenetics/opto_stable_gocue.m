clear
cd ./stable-cuelight
% C1S2:loop;C1S3:go cue;C1S4:go judge;C1S5:no gocue;C1S6:nogojudge;
% C1S7:go Hit;C1S8:go miss;C1S9:no go CR;C1S10:airpuff;OUT1:reward;OUT2:airpuff;
% C1S11:light on;C1S12:light off
control=dir('C*.mat');%control
inhibit=dir('I*.mat');%inhibition
performence=[];
for ii=1:length(control)
    load(control(ii).name)
    lighton_gouce=intersect(C1S3,C1S11);
    lightoff_gouce=intersect(C1S3,C1S12);
    hit=zeros(1,2);
    for i=1:length(lightoff_gouce)
        response=find(OUT1(:,1)>lightoff_gouce(i,:) & OUT1(:,1)<=lightoff_gouce(i,:)+3000);
        if ~isempty(response)
            hit(1,1)=hit(1,1)+1;
        end
    end
    for i=1:length(lighton_gouce)
        response=find(OUT1(:,1)>lighton_gouce(i,:) & OUT1(:,1)<=lighton_gouce(i,:)+3000);
        if ~isempty(response)
            hit(1,2)=hit(1,2)+1;
        end
    end
    performence.controloff(ii,:)=[hit(1,1) length(lightoff_gouce)-hit(1,1) length(C1S9) length(C1S10)];
    performence.controlon(ii,:)=[hit(1,2) length(lighton_gouce)-hit(1,2) length(C1S9) length(C1S10)];
    hitrate.control(ii,1)= hit(1,1)/length(lightoff_gouce)*100;
    hitrate.control(ii,2)=hit(1,2)/length(lighton_gouce)*100;
    clearvars -except i control active inhibit  hitrate performence
end
Behavior.control.dprime=[Discriminability(performence.controloff) Discriminability(performence.controlon)];
Behavior.control.hitrate= hitrate.control;

for ii=1:length(inhibit)
    C1S7=[];C1S8=[];C1S9=[]; C1S10=[];
    load(inhibit(ii).name)
    lighton_gouce=intersect(C1S3,C1S11);
    lightoff_gouce=intersect(C1S3,C1S12);
  
    hit=zeros(1,2);
    for i=1:length(lightoff_gouce)
        response=find(OUT1(:,1)>lightoff_gouce(i,:) & OUT1(:,1)<=lightoff_gouce(i,:)+3000);
        if ~isempty(response)
            hit(1,1)=hit(1,1)+1;
        end
    end
     for i=1:length(lighton_gouce)
        response=find(OUT1(:,1)>lighton_gouce(i,:) & OUT1(:,1)<=lighton_gouce(i,:)+3000);
        if ~isempty(response)
            hit(1,2)=hit(1,2)+1;
        end
    end
    performence.inhibitoff(ii,:)=[hit(1,1) length(lightoff_gouce)-hit(1,1) length(C1S9) length(C1S10)];
    performence.inhibiton(ii,:)=[hit(1,2) length(lighton_gouce)-hit(1,2) length(C1S9) length(C1S10)];
    hitrate.inhibit(ii,1)= hit(1,1)/length(lightoff_gouce)*100;
    hitrate.inhibit(ii,2)=hit(1,2)/length(lighton_gouce)*100;
    clearvars -except i control active inhibit  hitrate performence Behavior
end
Behavior.inhibit.dprime=[Discriminability(performence.inhibitoff) Discriminability(performence.inhibiton)];
Behavior.inhibit.hitrate= hitrate.inhibit;
cd ..
save('opto_stable_gocue','Behavior')

function d=Discriminability(Data)
%Data=[Hit Miss CR FA]
 for i=1:size(Data,1)
     hitrate=Data(i,1)/(Data(i,1)+Data(i,2));
     FArate=Data(i,4)/(Data(i,3)+Data(i,4));
     if hitrate==1
         hitrate=1-1/(2*(Data(i,1)+Data(i,2)));
     end
      if hitrate==0
         hitrate=1/(2*(Data(i,1)+Data(i,2)));
     end
     if FArate==0
        FArate=1/(2*(Data(i,3)+Data(i,4)));
     end
     if FArate==1
        FArate=1-1/(2*(Data(i,3)+Data(i,4)));
     end
   d(i,:)=norminv(hitrate) - norminv(FArate);
 end
end
  