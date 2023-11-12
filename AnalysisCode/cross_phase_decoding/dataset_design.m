clear
cd ..
load('binned_site_info.mat')
load('stable')
binned_data=[];binned_labels.stimulus_ID=[];
for i=1:549
        Hit=population.goHit.eachDF{i}(46:90,:)';
        Miss=population.goMiss.eachDF{i}(46:90,:)';
        CR=population.nogoCR.eachDF{i}(46:90,:)';
        FA=population.nogoFA.eachDF{i}(46:90,:)';
        data{i}=[Hit;Miss;CR;FA];
        n=size(data{i},1);
        stimulus_ID{i}=cell(1,n);
        for ii=1:size(Hit,1)+size(Miss,1)
            stimulus_ID{i}{ii}='3kHZ';
        end
        for jj=ii+1:n
            stimulus_ID{i}{jj}='12kHZ';
        end
        m=find(isnan(data{i}(:,1))==1);
        data{i}(m,:)=[];stimulus_ID{i}(m)=[];
     clearvars -except data stimulus_ID population Cellid binned_site_info
    end
binned_data=data;
binned_labels.stimulus_ID=stimulus_ID;
cd ./cross_phase_decoding
save('stable-gonogo','binned_data','binned_labels','binned_site_info') %design stable data

cd ..
clearvars -except binned_site_info
file=dir('ACC*.mat');
k=1;
for jj=1:length(file)
    load(file(jj).name)
    N=Info.Cellnumber;
    n=length(outcome);
    n1=fix(n*0.33);n2=fix(n*0.67);
    go{1}=[find(outcome(1:n1,1)==1);find(outcome(1:n1,1)==2);find(outcome(1:n1,1)==5)];
    go{2}=[find(outcome(n1+1:n2,1)==1);find(outcome(n1+1:n2,1)==2);find(outcome(n1+1:n2,1)==5)]+n1;
    go{3}=[find(outcome(n2+1:end,1)==1);find(outcome(n2+1:end,1)==2);find(outcome(n2+1:end,1)==5)]+n2;
    nogo{1}=[find(outcome(1:n1,1)==3);find(outcome(1:n1,1)==4)];
    nogo{2}=[find(outcome(n1+1:n2,1)==3);find(outcome(n1+1:n2,1)==4)]+n1;
    nogo{3}=[find(outcome(n2+1:end,1)==3);find(outcome(n2+1:end,1)==4)]+n2;
    for i=1:N
        total=eachDF{1, i}(46:90,:);
        for ik=1:3
            uncertain.go{ik}=total(:,go{ik});
            uncertain.nogo{ik}=total(:,nogo{ik});
            response{ik,k}=[uncertain.go{ik} uncertain.nogo{ik}]';
            stimulus=[ones(length(go{ik}),1);zeros(length(nogo{ik}),1)];
            for ii=1:length(stimulus)
                if stimulus(ii,:)==1
                    ID{ik,k}{ii}='3kHZ';
                else
                    ID{ik,k}{ii}='12kHZ';
                end
            end
        end
         k=k+1;
    end
   
end
cd ./cross_phase_decoding
load('binned_site_info.mat')
binned_data=[];binned_labels.stimulus_ID=[];
binned_data=response(1,:);binned_labels.stimulus_ID=ID(1,:);
save('uncertain1-gonogo','binned_data','binned_labels','binned_site_info')

binned_data=response(2,:);binned_labels.stimulus_ID=ID(2,:);
save('uncertain2-gonogo','binned_data','binned_labels','binned_site_info')

binned_data=response(3,:);binned_labels.stimulus_ID=ID(3,:);
save('uncertain3-gonogo','binned_data','binned_labels','binned_site_info')
