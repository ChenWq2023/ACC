clear
cd ./opto_sponlick
% C1S2:light;
control=dir('C*.mat');
inhibit=dir('I*.mat');
active=dir('A*.mat');
k=1;
for j=1:length(control)
    load(control(j).name)
    light=C1S2;
    lickp.control(j,1)=0;lickp.control(j,2)=0;lickp.control(j,3)=0;
    
    for i=1:20
        t=light(i);
        lick1=find(IN1(:,1)>=t-1000 & IN1(:,1)<=t+2000);
        plick=(IN1(lick1,1)-t)/1000;
        e=[-1:0.05:2];
        psth(:,i)=histc(plick,e)/0.05;
        lick1=find(IN1(:,1)>t-1000 & IN1(:,1)<=t);
        if ~isempty(lick1)
            lickp.control(j,1)=lickp.control(j,1)+1;
        end
        lick2=find(IN1(:,1)>t & IN1(:,1)<=t+1000);
        if ~isempty(lick2)
            lickp.control(j,2)=lickp.control(j,2)+1;
        end
        lick3=find(IN1(:,1)>t+1000 & IN1(:,1)<=t+2000);
        if ~isempty(lick3)
            lickp.control(j,3)=lickp.control(j,3)+1;
        end
        lick4=find(IN1(:,1)>t & IN1(:,1)<=t+2000);
        if ~isempty(lick4)
            licklatency.control(k,1)=(IN1(lick4(1),1)-t)/1000;
            k=k+1;
        end
    end
    lighttrace.control(:,j)=mean(psth,2);
    clearvars -except j control active inhibit  lighttrace lickp licklatency k
end
k=1;
for j=1:length(active)
    load(active(j).name)
    light=C1S2;
    lickp.active(j,1)=0;
    lickp.active(j,2)=0;
    lickp.active(j,3)=0;
    
    for i=1:20
        t=light(i);
        lick1=find(IN1(:,1)>=t-1000 & IN1(:,1)<=t+2000);
        plick=(IN1(lick1,1)-t)/1000;
        e=[-1:0.05:2];
        psth(:,i)=histc(plick,e)/0.05;
        lick1=find(IN1(:,1)>t-1000 & IN1(:,1)<=t);
        if ~isempty(lick1)
            lickp.active(j,1)=lickp.active(j,1)+1;
        end
        lick2=find(IN1(:,1)>t & IN1(:,1)<=t+1000);
        if ~isempty(lick2)
            lickp.active(j,2)=lickp.active(j,2)+1;
        end
        lick3=find(IN1(:,1)>t+1000 & IN1(:,1)<=t+2000);
        if ~isempty(lick3)
            lickp.active(j,3)=lickp.active(j,3)+1;
        end
        lick4=find(IN1(:,1)>t & IN1(:,1)<=t+2000);
        if ~isempty(lick4)
            licklatency.active(k,1)=(IN1(lick4(1),1)-t)/1000;
            k=k+1;
        end
    end
    lighttrace.active(:,j)=mean(psth,2);
    clearvars -except j control active inhibit  lighttrace lickp licklatency k
end
k=1;
for j=1:length(inhibit)
    load(inhibit(j).name)
    light=C1S2;
    lickp.inhibit(j,1)=0;
    lickp.inhibit(j,2)=0;
    lickp.inhibit(j,3)=0;
    
    for i=1:20
        t=light(i);
        lick1=find(IN1(:,1)>=t-1000 & IN1(:,1)<=t+2000);
        plick=(IN1(lick1,1)-t)/1000;
        e=[-1:0.05:2];
        psth(:,i)=histc(plick,e)/0.05;
        lick1=find(IN1(:,1)>t-1000 & IN1(:,1)<=t);
        if ~isempty(lick1)
            lickp.inhibit(j,1)=lickp.inhibit(j,1)+1;
        end
        lick2=find(IN1(:,1)>t & IN1(:,1)<=t+1000);
        if ~isempty(lick2)
            lickp.inhibit(j,2)=lickp.inhibit(j,2)+1;
        end
        lick3=find(IN1(:,1)>t+1000 & IN1(:,1)<=t+2000);
        if ~isempty(lick3)
            lickp.inhibit(j,3)=lickp.inhibit(j,3)+1;
        end
        lick4=find(IN1(:,1)>t & IN1(:,1)<=t+2000);
        if ~isempty(lick4)
            licklatency.inhibit(k,1)=(IN1(lick4(1),1)-t)/1000;
            k=k+1;
        end
    end
    lighttrace.inhibit(:,j)=mean(psth,2);
    clearvars -except j control active inhibit  lighttrace lickp licklatency k
end
cd ..
save('opto_lick','control', 'active', 'inhibit','lighttrace','lickp', 'licklatency')
