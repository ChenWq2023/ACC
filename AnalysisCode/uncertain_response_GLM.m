%first download and add GLM toolbox: https://github.com/benengx
%Engelhard, B., Finkelstein, J., Cox, J. et al. Specialized coding of sensory, motor and cognitive variables in VTA dopamine neurons. Nature 570, 509–513 (2019).
clear
file=dir('ACC*uncertain*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
    totalevent=sort([Events.C1S3;Events.C1S5;Events.C1S12]); 
    eventframe=findFrameForEvent(Events.IN3,totalevent);
    N=Info.Cellnumber;
    L=findFrameForEvent(Events.IN3,Events.IN1);%lick rate/frame
    edge=[1:1:length(Events.IN3)];
    LR=histc(L,edge);

    gotrial=find(outcome(:,1)==1 |outcome(:,1)==2 | outcome(:,1)==5);
    gotrial(find(gotrial<=1),:)=[];
    unexpn=length(find(outcome(:,1)==5 |outcome(:,1)==6));
    cumhistory=ones(30,length(gotrial));
    history=ones(30,length(gotrial));
    for i=1:length(gotrial)
        stimulusframe=eventframe(gotrial(i,:),:);
        LS(:,i)=LR(stimulusframe:stimulusframe+29,:);%lick rate/frame
        pt=outcome(gotrial(i,:)-1,1);%previous trial
        if pt==5 |  pt==6 %ro/ur
            history(:,i)=1;
        else
            history(:,i)=0;
        end
        allpretrial=outcome(1:gotrial(i,:)-1,1);
        cumhistory(:,i)=length(find(allpretrial==5 | allpretrial==6))/unexpn;%cum unexpect trials
    end
    s=ones(30,length(gotrial));
    for i=1:N
        totalDF=eachDF{i}(:,gotrial);
        predictor.previousoutcome{k}=history;
        predictor.cumhistory{k}=cumhistory;
        predictor.lickevent{k}=LS;
        predictor.neurontrace{k}=totalDF(61:90,:);
        predictor.stim{k}=s;
        k=k+1;
    end
end
%design var
for i=1:549
    for j=1:size(predictor.stim{i},2)
        eachpredictor{i}{1}{j}=predictor.stim{i}(:,j);
        eachpredictor{i}{2}=predictor.previousoutcome{i}(1,:);
        eachpredictor{i}{3}=predictor.cumhistory{i}(1,:);
        eachpredictor{i}{4}{j}= predictor.lickevent{i}(:,j);
        eachtrace{i}{j}=predictor.neurontrace {i} (:,j);
    end
end
var_types=[{'event'}    {'whole-trial'}   {'whole-trial'} {'continuous'} ];
for i=1:549
    [pred_allmat,pred_inds_cell,grouped_var_types] = make_predictor_matrix_generalcase(eachpredictor{i},var_types);
    [relative_contrib(i,:),Fstat_mat(i,:),full_R2_vec(i,:),predicted_gcamp{i},B_all{i},pred_inds_cell_opt(i,:)] = process_encoding_model(pred_allmat, pred_inds_cell, eachtrace{i}, var_types);
end
save('uncertain_response_GLM.mat','predictor','relative_contrib','Fstat_mat','full_R2_vec','predicted_gcamp','pred_inds_cell_opt')

