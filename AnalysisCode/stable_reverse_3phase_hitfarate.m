clear
file=dir('ACC*reverse*.mat');
for jj=1:5
    load(file(jj).name)
    n=length(outcome);n1=fix(n*0.15);n2=fix(n*0.50);
    go{1}=[find(outcome(1:n1,1)==1);find(outcome(1:n1,1)==2);];
    go{2}=[find(outcome(n1+1:n2,1)==1);find(outcome(n1+1:n2,1)==2)]+n1;
    go{3}=[find(outcome(n2+1:end,1)==1);find(outcome(n2+1:end,1)==2)]+n2;
    nogo{1}=[find(outcome(1:n1,1)==3);find(outcome(1:n1,1)==4)];
    nogo{2}=[find(outcome(n1+1:n2,1)==3);find(outcome(n1+1:n2,1)==4)]+n1;
    nogo{3}=[find(outcome(n2+1:end,1)==3);find(outcome(n2+1:end,1)==4)]+n2;
    for ik=1:3
        gotrial=outcome(go{ik},1);nogotrial=outcome(nogo{ik},1);
        hitrate(jj,ik)=100-length(find(gotrial==2))./length(gotrial)*100;
        farate(jj,ik)=length(find(nogotrial==4))./length(nogotrial)*100;
    end
end

f1=dir('ACC*stable-DF.mat');
for i=1:length(f1)
    load(f1(i).name)
    stable_hit(i,1)=Info.Hit/(Info.Hit+Info.Miss)*100;
    stable_fa(i,3)=Info.FA/(Info.CR+Info.FA)*100;
end
hitrate=[stable_hit hitrate];farate=[stable_fa farate];
T3lick=[stable_hit farate];T12lick=[stable_fa hitrate];
save('reverse_hitfarate_3phase','hitrate','farate','T3lick','T12lick')
