clear
cd ./uncertain-responselight
% C1S2:loop;C1S3:go cue;C1S4:go judge;C1S5:no gocue;C1S6:nogojudge;
% C1S7:go Hit;C1S8:go miss;C1S9:no go CR;C1S10:airpuff;OUT1:reward;OUT2:airpuff;
% C1S11:reward omit;C1S12:unceud reward; OUT5:light
control=dir('C*.mat');
inhibit=dir('I*.mat');
performence=[];
for i=1:length(control)
    load(control(i).name)
    if ~isempty(C1S11)
        ik=1;
        for k=1:length(C1S3)
         tem=find(C1S11>=C1S3(k,:) & C1S11<=C1S3(k,:)+3000);
         if  ~isempty(tem)
             ro(ik,:)=C1S11(tem);
             ik=ik+1;
        end
        end
    else
        ro=[];
    end
   performence(i,:)=[(length(C1S7)+length(ro)) length(C1S8) length(C1S9) length(C1S10)];
   clearvars -except i control active inhibit  performence Behavior
end
Behavior.control.uncertain= performence(1:2:end,:);
Behavior.control.stable= performence(2:2:end,:);
Behavior.control.farate= [Behavior.control.stable(:,4)./sum(Behavior.control.stable(:,3:4),2) Behavior.control.uncertain(:,4)./sum(Behavior.control.uncertain(:,3:4),2)];
Behavior.control.hitrate= [Behavior.control.stable(:,1)./sum(Behavior.control.stable(:,1:2),2) Behavior.control.uncertain(:,1)./sum(Behavior.control.uncertain(:,1:2),2)];
Behavior.control.dprime=[Discriminability(Behavior.control.stable) Discriminability(Behavior.control.uncertain)];

performence=[];
for i=1:length(inhibit)
    load(inhibit(i).name)
    if ~isempty(C1S11)
        ik=1;
        for k=1:length(C1S3)
         tem=find(C1S11>=C1S3(k,:) & C1S11<=C1S3(k,:)+3000);
         if  ~isempty(tem)
             ro(ik,:)=C1S11(tem);
             ik=ik+1;
        end
        end
    else
        ro=[];
    end
   performence(i,:)=[(length(C1S7)+length(ro)) length(C1S8) length(C1S9) length(C1S10)];
   clearvars -except i control active inhibit  performence Behavior
end
Behavior.inhibit.uncertain= performence(1:2:end,:);
Behavior.inhibit.stable= performence(2:2:end,:);
Behavior.inhibit.farate= [Behavior.inhibit.stable(:,4)./sum(Behavior.inhibit.stable(:,3:4),2) Behavior.inhibit.uncertain(:,4)./sum(Behavior.inhibit.uncertain(:,3:4),2)];
Behavior.inhibit.hitrate= [Behavior.inhibit.stable(:,1)./sum(Behavior.inhibit.stable(:,1:2),2) Behavior.inhibit.uncertain(:,1)./sum(Behavior.inhibit.uncertain(:,1:2),2)];
Behavior.inhibit.dprime=[Discriminability(Behavior.inhibit.stable) Discriminability(Behavior.inhibit.uncertain)];
cd ..
save('opto_uncertain_response','Behavior')

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
  