clear
close all
file=dir('ACC*uncertain*.mat');
k=1;
for jj=1:length(file)
     load(file(jj).name)
    n=length(outcome);
    n1=fix(n*0.33);n2=fix(n*0.67);
    gotrial{1}=find(outcome(1:n1,1)==1|outcome(1:n1,1)==2|outcome(1:n1,1)==5);
    gotrial{2}=find(outcome(n1+1:n2,1)==1|outcome(n1+1:n2,1)==2|outcome(n1+1:n2,1)==5)+n1;
    gotrial{3}=find(outcome(n2+1:end,1)==1|outcome(n2+1:end,1)==2|outcome(n2+1:end,1)==5)+n2;
    gotrial{1}(find(gotrial{1}<=1))=[];
    for ik=1:3
        pervious_trial=outcome(gotrial{ik}-1,1);%previous trial
        normal_trial=find(pervious_trial==1|pervious_trial==2|pervious_trial==3|pervious_trial==4);
        unexpect_trial=find(pervious_trial==5|pervious_trial==6);
        nt_g{ik}=gotrial{ik}(normal_trial);nt_g{ik}(:,2)=outcome(nt_g{ik},1);
        ug_g{ik}=gotrial{ik}(unexpect_trial);ug_g{ik}(:,2)=outcome(ug_g{ik},1);
        
        hitrate{ik}(jj,1)=100-length(find(nt_g{ik}(:,2)==2))/length(nt_g{ik}(:,1))*100;
        hitrate{ik}(jj,2)=100-length(find(ug_g{ik}(:,2)==2))/length(ug_g{ik}(:,1))*100;
    end
    for i=1:Info.Cellnumber
        total=eachDF{i};
        totalz=(total-mean(total(1:60,:)))./std(total(1:60,:));
        for ik=1:3
            previousoutcome.ugDF{ik}(:,k)=mean(total(46:90,ug_g{ik}(:,1)),2);
            previousoutcome.ntDF{ik}(:,k)=mean(total(46:90,nt_g{ik}(:,1)),2);
            previousoutcome.ug_meanZ(k,ik)=mean(mean(totalz(61:90,ug_g{ik}(:,1))));
            previousoutcome.nt_meanZ(k,ik)=mean(mean(totalz(61:90,nt_g{ik}(:,1))));
        end
        k=k+1;
    end
    clearvars -except previousoutcome k jj file hitrate
end
%normalized to -0.5~0 s
for ik=1:3
    previousoutcome.ugZ{ik}=(previousoutcome.ugDF{ik}-mean(previousoutcome.ugDF{ik}(1:15,:)))./std(previousoutcome.ugDF{ik}(1:15,:));
    previousoutcome.ntZ{ik}=(previousoutcome.ntDF{ik}-mean(previousoutcome.ntDF{ik}(1:15,:)))./std(previousoutcome.ntDF{ik}(1:15,:));
end
save('uncertain_3phase_previousoutcome','previousoutcome','hitrate')