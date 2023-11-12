clear
cd ./reverse-cuelight
control=dir('C*cuelight*.mat');
inhibit=dir('I*cuelight*.mat');
for j=1:length(control)
    load(control(j).name)
    if ~isempty(C1S7)
        C1S7(:,2)=1;%hit
    end
    if ~isempty(C1S8)
        C1S8(:,2)=2;%miss
    end
    if ~isempty(C1S9)
        C1S9(:,2)=3;%cr
    end
    if ~isempty(C1S10)
        C1S10(:,2)=4;%fa
    end
    time=sortrows([C1S7;C1S8;C1S9;C1S10;]);
    n=length(time);
    for i=1:n
        if i+4<=n
            farate.control(i,j)=length(find(time(i:i+4,2)==4))/length([find(time(i:i+4,2)==4);find(time(i:i+4,2)==3)]);
            if isnan(farate.control(i,j))
                farate.control(i,j)=farate.control(i-1,j);
            end
        else
            farate.control(i,j)=length(find(time(i:n,2)==4))/length([find(time(i:n,2)==4);find(time(i:n,2)==3)]);
            if isnan(farate.control(i,j))
                farate.control(i,j)=farate.control(i-1,j);
            end
        end
    end
    clearvars -except i control active inhibit  farate
end
for j=1:length(inhibit)
    C1S7=[];C1S8=[];C1S9=[]; C1S10=[];
    load(inhibit(j).name)
      if ~isempty(C1S7)
        C1S7(:,2)=1;%hit
    end
    if ~isempty(C1S8)
        C1S8(:,2)=2;%miss
    end
    if ~isempty(C1S9)
        C1S9(:,2)=3;%cr
    end
    if ~isempty(C1S10)
        C1S10(:,2)=4;%fa
    end
    time=sortrows([C1S7;C1S8;C1S9;C1S10;]);
    n=length(time);
    for i=1:n
        if i+4<=n
            farate.inhibit(i,j)=length(find(time(i:i+4,2)==4))/length([find(time(i:i+4,2)==4);find(time(i:i+4,2)==3)]);
            if isnan(farate.inhibit(i,j))
                farate.inhibit(i,j)=farate.inhibit(i-1,j);
            end
        else
            farate.inhibit(i,j)=length(find(time(i:n,2)==4))/length([find(time(i:n,2)==4);find(time(i:n,2)==3)]);
            if isnan(farate.inhibit(i,j))
                farate.inhibit(i,j)=farate.inhibit(i-1,j);
            end
        end
    end
     clearvars -except i control active inhibit  farate
end
cd ..
save('opto_reverse_gocue_FArate','farate')