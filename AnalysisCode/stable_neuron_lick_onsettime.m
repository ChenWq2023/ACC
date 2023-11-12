clear
file=dir('ACC*stable*.mat');
k=1;lick_onset=[];neuron_oneset=[];
for jj=1:length(file)
    load(file(jj).name)
    totalevent=sort([Events.C1S3;Events.C1S5]); 
    hit=find(outcome(:,1)==1);
    licktime=[];
     for i=1:length(hit)
         cuetime=totalevent(hit(i),1);
         tp=find(Events.IN1>=cuetime & Events.IN1<=cuetime+3000);
         licktime(i,:)=(Events.IN1(tp(1))-cuetime)/1000;
     end
         lick_onset=[lick_onset;licktime];
    p=[];
    for i=1:Info.Cellnumber
        hitDF=eachDF{i}(:,hit);
        b=hitDF(1:60,:);
        s=hitDF(61:93,:);
        for j=1:length(hit)
            for jk=1:30
                p(j,jk)=ranksum(b(:,j),s(jk:jk+3,j));
            end
          sp=find(p(j,:)<0.01);%p<0.01
          if ~isempty(sp)
              neuron_oneset(k,1)=sp(1)/30;
              k=k+1;
          end
      end
    end
end
save('onsettime','neuron_oneset','lick_onset')