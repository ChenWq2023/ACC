clear
file=dir('ACC*restable*.mat');
for jj=1:5
    load(file(jj).name)
    n=length(outcome);n1=fix(n*0.33);n2=fix(n*0.67);
    go{1}=[find(outcome(1:n1,1)==1);find(outcome(1:n1,1)==2);];
    go{2}=[find(outcome(n1+1:n2,1)==1);find(outcome(n1+1:n2,1)==2)]+n1;
    go{3}=[find(outcome(n2+1:n,1)==1);find(outcome(n2+1:n,1)==2)]+n2;
    nogo{1}=[find(outcome(1:n1,1)==3);find(outcome(1:n1,1)==4)];
    nogo{2}=[find(outcome(n1+1:n2,1)==3);find(outcome(n1+1:n2,1)==4)]+n1;
    nogo{3}=[find(outcome(n2+1:n,1)==3);find(outcome(n2+1:n,1)==4)]+n2;
    for ik=1:3
        gotrial=outcome(go{ik},1);nogotrial=outcome(nogo{ik},1);
        restable.hitrate(jj,ik)=length(find(gotrial==1))./length(gotrial)*100;
        restable.farate(jj,ik)=length(find(nogotrial==4))./length(nogotrial)*100;
    end
end

clearvars -except restable
file=dir('ACC*stable*.mat');
for jj=1:5
     load(file(jj).name)
    n=length(outcome);n1=fix(n*0.33);n2=fix(n*0.67);
    go{1}=[find(outcome(1:n1,1)==1);find(outcome(1:n1,1)==2);];
    go{2}=[find(outcome(n1+1:n2,1)==1);find(outcome(n1+1:n2,1)==2)]+n1;
    go{3}=[find(outcome(n2+1:end,1)==1);find(outcome(n2+1:end,1)==2)]+n2;
    nogo{1}=[find(outcome(1:n1,1)==3);find(outcome(1:n1,1)==4)];
    nogo{2}=[find(outcome(n1+1:n2,1)==3);find(outcome(n1+1:n2,1)==4)]+n1;
    nogo{3}=[find(outcome(n2+1:end,1)==3);find(outcome(n2+1:end,1)==4)]+n2;
    for ik=1:3
        gotrial=outcome(go{ik},1);nogotrial=outcome(nogo{ik},1);
        stable.hitrate(jj,ik)=length(find(gotrial==1))./length(gotrial)*100;
        stable.farate(jj,ik)=length(find(nogotrial==4))./length(nogotrial)*100;
    end
end

save('stable_restable_3phase_hitfarate','restable','stable')