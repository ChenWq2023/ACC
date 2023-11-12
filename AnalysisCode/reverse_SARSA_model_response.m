
clear
load('reverse.mat')
load('reverse_outcomecell_identify.mat')
load('reverse_valuecell_identify.mat')
eachoutcome=Cellid(outcome.cell,:);
eachvalue=Cellid(value.cell,:);
dualcell=intersect(outcome.cell,value.cell);
eachdual=Cellid(dualcell,:);
for i=1:5
    eachmice.outcome{i}=eachoutcome(find(eachoutcome(:,1)==i),2);
    eachmice.value{i}=eachvalue(find(eachvalue(:,1)==i),2);
    eachmice.dual{i}=eachdual(find(eachdual(:,1)==i),2);
end
save('eachmice','eachmice')
%%
clear
load('eachmice.mat')
load('SARSA_model.mat')
file=dir('ACC*reverse*.mat');
ntrial=10;
for ik=1:length(file)
    load(file(ik).name)
    nogo=find(outcome(:,1)==3 | outcome(:,1)==4);
    nogotrial=outcome(nogo,:);
    for i=1:Info.Cellnumber
        total=eachDF{i};
        totalZ{i}=(total-mean(total(1:60,:)))./std(total(1:60,:));
        for j=1:length(outcome)
            trialZ{j}(:,i)=totalZ{i}(:,j);
        end    
    end
    nogotZ=trialZ(nogo);
    outcometime=outcome(nogo,2)+60;
     for i=1:length(nogotZ)
        sz(:,i)=mean(nogotZ{i}(61:90,:));
        oz(:,i)=mean(nogotZ{i}(outcometime(i,:):outcometime(i,:)+29,:));
     end    
     dual_neuron=eachmice.dual{ik};
     total_sz{ik}=sz;dual_sz{ik}=sz(dual_neuron,:);
     sz(dual_neuron,:)=[];other_sz{ik}=sz;
     total_oz{ik}=oz; dual_oz{ik}=oz(dual_neuron,:);
     oz(dual_neuron,:)=[];other_oz{ik}=oz;
     clearvars -except dual_sz file ik total_sz other_sz ntrial model other_oz dual_oz total_oz eachmice
end
for i=1:5
    qvalue(i,:)=model.reverse.lick_q{i}(1:ntrial,:);
    PEvalue(i,:)=model.reverse.pe{i}(2:ntrial+1,:);
    FA{i}=find(model.reverse.outcome{i}(1:ntrial,1)==4);
end
save('SARSA_model_response','FA','qvalue','PEvalue','dual_sz','other_sz','dual_oz','other_oz')