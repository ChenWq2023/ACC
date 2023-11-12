clear
cd ./opto_gocue_withchr2
% C1S2:loop;C1S3:go cue;C1S4:go judge;C1S5:no gocue;C1S6:nogojudge;
% C1S7:go Hit;C1S8:go miss;C1S9:no go CR;C1S10:airpuff;OUT1:reward;OUT2:airpuff;
% C1S11:light on; % C1S12:light off;
control=dir('C*.mat');
inhibit=dir('I*.mat');
active=dir('A*.mat');
for j=1:length(control)
 
    load(control(j).name)
    lighton_gouce=intersect(C1S3,C1S11);
    lightoff_gouce=intersect(C1S3,C1S12);
    lick_on.control(j,1)=0;lick_on.control(j,2)=0;lick_on.control(j,3)=0;
    lick_off.control(j,1)=0;lick_off.control(j,2)=0;lick_off.control(j,3)=0;
    for i=1:20
        t=lighton_gouce(i);
        lick1=find(IN1(:,1)>=t-1000 & IN1(:,1)<=t+2000);
        plick=(IN1(lick1,1)-t)/1000;
        e=[-1:0.05:3];
        psth_on(:,i)=histc(plick,e)/0.05;
        lick1=find(IN1(:,1)>t-1000 & IN1(:,1)<=t);
        licktime_on.control{j}(i,1)=length(lick1);
        if ~isempty(lick1)
          lick_on.control(j,1)=lick_on.control(j,1)+1;
        end
       lick2=find(IN1(:,1)>t & IN1(:,1)<=t+1000);
       licktime_on.control{j}(i,2)=length(lick2);
        if ~isempty(lick2)
          lick_on.control(j,2)=lick_on.control(j,2)+1;
        end
        lick3=find(IN1(:,1)>t+1000 & IN1(:,1)<=t+2000);
        licktime_on.control{j}(i,3)=length(lick3);
        if ~isempty(lick3)
          lick_on.control(j,3)=lick_on.control(j,3)+1;
        end
 
    end    
    lighttrace_on.control(:,j)=mean(psth_on,2);
    for i=1:20
        t=lightoff_gouce(i);
        lick1=find(IN1(:,1)>=t-1000 & IN1(:,1)<=t+2000);
        plick=(IN1(lick1,1)-t)/1000;
        e=[-1:0.05:3];
        psth_off(:,i)=histc(plick,e)/0.05;
        lick1=find(IN1(:,1)>t-1000 & IN1(:,1)<=t);
        licktime_off.control{j}(i,1)=length(lick1);
        if ~isempty(lick1)
          lick_off.control(j,1)=lick_off.control(j,1)+1;
        end
       lick2=find(IN1(:,1)>t & IN1(:,1)<=t+1000);
       licktime_off.control{j}(i,2)=length(lick2);
        if ~isempty(lick2)
          lick_off.control(j,2)=lick_off.control(j,2)+1;
        end
        lick3=find(IN1(:,1)>t+1000 & IN1(:,1)<=t+2000);
        licktime_off.control{j}(i,3)=length(lick3);
        if ~isempty(lick3)
          lick_off.control(j,3)=lick_off.control(j,3)+1;
        end
        
    end    
    lighttrace_off.control(:,j)=mean(psth_off,2);
    clearvars -except j control active inhibit  lighttrace_off lighttrace_on lick_off lick_on licktime_on licktime_off
end
for j=1:length(active)
    
    load(active(j).name)
    lighton_gouce=intersect(C1S3,C1S11);
    lightoff_gouce=intersect(C1S3,C1S12);
    lick_on.active(j,1)=0;lick_on.active(j,2)=0;lick_on.active(j,3)=0;
    lick_off.active(j,1)=0;lick_off.active(j,2)=0;lick_off.active(j,3)=0;
    for i=1:20
        t=lighton_gouce(i);
        lick1=find(IN1(:,1)>=t-1000 & IN1(:,1)<=t+2000);
        plick=(IN1(lick1,1)-t)/1000;
        e=[-1:0.05:3];
        psth_on(:,i)=histc(plick,e)/0.05;
        licktime_on.active{j}(i,1)=length(lick1);

        lick1=find(IN1(:,1)>t-1000 & IN1(:,1)<=t);
        if ~isempty(lick1)
          lick_on.active(j,1)=lick_on.active(j,1)+1;
        end
       lick2=find(IN1(:,1)>t & IN1(:,1)<=t+1000);
       licktime_on.active{j}(i,2)=length(lick2);

        if ~isempty(lick2)
          lick_on.active(j,2)=lick_on.active(j,2)+1;
        end
        

        lick3=find(IN1(:,1)>t+1000 & IN1(:,1)<=t+2000);
         licktime_on.active{j}(i,3)=length(lick3);
        if ~isempty(lick3)
          lick_on.active(j,3)=lick_on.active(j,3)+1;
        end
 
    end    
    lighttrace_on.active(:,j)=mean(psth_on,2);
    for i=1:20
        t=lightoff_gouce(i);
        lick1=find(IN1(:,1)>=t-1000 & IN1(:,1)<=t+2000);
        plick=(IN1(lick1,1)-t)/1000;
        e=[-1:0.05:3];
        psth_off(:,i)=histc(plick,e)/0.05;
        lick1=find(IN1(:,1)>t-1000 & IN1(:,1)<=t);
        licktime_off.active{j}(i,1)=length(lick1);
 
        if ~isempty(lick1)
          lick_off.active(j,1)=lick_off.active(j,1)+1;
        end
       lick2=find(IN1(:,1)>t & IN1(:,1)<=t+1000);
       licktime_off.active{j}(i,2)=length(lick2);

        if ~isempty(lick2)
          lick_off.active(j,2)=lick_off.active(j,2)+1;
        end
        lick3=find(IN1(:,1)>t+1000 & IN1(:,1)<=t+2000);
        licktime_off.active{j}(i,3)=length(lick3);
        if ~isempty(lick3)
          lick_off.active(j,3)=lick_off.active(j,3)+1;
        end
        
    end    
    lighttrace_off.active(:,j)=mean(psth_off,2);
     clearvars -except j control active inhibit  lighttrace_off lighttrace_on lick_off lick_on licktime_on licktime_off
end
for j=1:length(inhibit)
  
    load(inhibit(j).name)
    lighton_gouce=intersect(C1S3,C1S11);
    lightoff_gouce=intersect(C1S3,C1S12);
    lick_on.inhibit(j,1)=0;lick_on.inhibit(j,2)=0;lick_on.inhibit(j,3)=0;
    lick_off.inhibit(j,1)=0;lick_off.inhibit(j,2)=0;lick_off.inhibit(j,3)=0;
    for i=1:20
        t=lighton_gouce(i);
        lick1=find(IN1(:,1)>=t-1000 & IN1(:,1)<=t+2000);
        plick=(IN1(lick1,1)-t)/1000;
        e=[-1:0.05:3];
        psth_on(:,i)=histc(plick,e)/0.05;
        lick1=find(IN1(:,1)>t-1000 & IN1(:,1)<=t);
        licktime_on.inhibit{j}(i,1)=length(lick1);

        if ~isempty(lick1)
          lick_on.inhibit(j,1)=lick_on.inhibit(j,1)+1;
        end
       lick2=find(IN1(:,1)>t & IN1(:,1)<=t+1000);
       licktime_on.inhibit{j}(i,2)=length(lick2);

        if ~isempty(lick2)
          lick_on.inhibit(j,2)=lick_on.inhibit(j,2)+1;
        end
        lick3=find(IN1(:,1)>t+1000 & IN1(:,1)<=t+2000);
         licktime_on.inhibit{j}(i,3)=length(lick3);

        if ~isempty(lick3)
          lick_on.inhibit(j,3)=lick_on.inhibit(j,3)+1;
        end
 
    end    
    lighttrace_on.inhibit(:,j)=mean(psth_on,2);
    for i=1:20
        t=lightoff_gouce(i);
        lick1=find(IN1(:,1)>=t-1000 & IN1(:,1)<=t+2000);
        plick=(IN1(lick1,1)-t)/1000;
        e=[-1:0.05:3];
        psth_off(:,i)=histc(plick,e)/0.05;
        lick1=find(IN1(:,1)>t-1000 & IN1(:,1)<=t);
        licktime_off.inhibit{j}(i,1)=length(lick1);
 
        if ~isempty(lick1)
          lick_off.inhibit(j,1)=lick_off.inhibit(j,1)+1;
        end
       lick2=find(IN1(:,1)>t & IN1(:,1)<=t+1000);
       licktime_off.inhibit{j}(i,2)=length(lick2);

        if ~isempty(lick2)
          lick_off.inhibit(j,2)=lick_off.inhibit(j,2)+1;
        end
        lick3=find(IN1(:,1)>t+1000 & IN1(:,1)<=t+2000);
        licktime_off.inhibit{j}(i,3)=length(lick3);
        if ~isempty(lick3)
          lick_off.inhibit(j,3)=lick_off.inhibit(j,3)+1;
        end
        
    end    
    lighttrace_off.inhibit(:,j)=mean(psth_off,2);
   clearvars -except j control active inhibit  lighttrace_off lighttrace_on lick_off lick_on licktime_on licktime_off
end
cd ..
save('opto_gocue_withchr2','control', 'active', 'inhibit','lighttrace_off','lighttrace_on', 'lick_off', 'lick_on', 'licktime_off', 'licktime_on')
