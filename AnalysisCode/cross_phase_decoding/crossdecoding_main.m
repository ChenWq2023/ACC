%first download and add the Neural Decoding Toolbox (NDT) :http://www.readout.info/downloads/
%Meyers, E. (2013). The Neural Decoding Toolbox. Frontiers in Neuroinformatics, 7:8
% dataset_design,uncertain split 3 phase
dataset_design
% train by one phase, test by other phase
stabletrain_uncertaintest
uncertain1train_uncertaintest
uncertain2train_uncertaintest
uncertain3train_uncertaintest
%% result extraction
clear
file=dir('*result.mat');
for i=1:length(file)
    load(file(i).name)
    t1=squeeze((mean(DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS1.decoding_results*100, 2)))';%T1
    M1=mean(t1(31:45,:))';
    t2=squeeze((mean(DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS2.decoding_results*100, 2)))';%T2
    M2=mean(t2(31:45,:))';
    t3=squeeze((mean(DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS3.decoding_results*100, 2)))';%T3
    M3=mean(t3(31:45,:))';
    each_session_result{i}=[M1 M2 M3];
end
decording_result=cell(1,3);
for i=1:3
    for j=1:4
        decording_result{1,i}=[decording_result{1,i} each_session_result{j}(:,i)];
        mean_decording_result(i,j)=mean(each_session_result{j}(:,i));
    end
    [p,tbl,stats] = kruskalwallis(decording_result{1,i},[],'off');
    c{i} = multcompare(stats,'CType','bonferroni','display','off');
end
save('totaldecodingdata','decording_result','mean_decording_result','c')
%% fig 2.h
clear
load('totaldecodingdata.mat')
figure('Name','fig2.h')
set(gcf,'unit','centimeters','position',[10 0 8.5 7.5])
label_y={'T1','T2','T3'};label_x={'I','II','III','IV'};
h=heatmap(mean_decording_result);h.Colormap=summer;h.ColorLimits=[80,95];h.GridVisible='on';h.ColorbarVisible='on';
h.CellLabelColor=[0,0,0];h.MissingDataColor=[1,1,1];h.FontName='Arial';h.FontSize=11;h.CellLabelFormat='%0.4g';
h.XDisplayLabels=label_x;h.YDisplayLabels=label_y;xlabel('Classifier')
%% fig 2.i
clear
load('totaldecodingdata.mat')
cdata=[255 160 64;65 240 174; 24 202 219;36 100 240]/255;
fillcolors=flip(cdata);edgecolor=[0,0,0]; 
data=decording_result{3};
figure('Name','fig2.i')
set(gcf,'unit','centimeters','position',[20 0 8.25 7.5])
set(gca,'position',[0.15,0.15,0.7,0.7],'color','none')
position = [1:1:4];  % define position for first group boxplot
box1= boxplot(data,'positions',position,'colors',edgecolor,'width',0.5,'ExtremeMode','compress','notch','on','symbol','');
boxobj = findobj(gca,'Tag','Box');
for j=1:4
    patch(get(boxobj(j),'XData'),get(boxobj(j),'YData'),fillcolors(j,:),'FaceAlpha',0.5);
end
box off
xlim([0.5,4.5]),ylim([60,100]),xticks([1:1:4]),yticks([60:10:100]),xticklabels={'I','II','III','IV'};
xlabel('Classifier');ylabel('Classification Accuracy (%)');
set(gca,'color','none','xcolor',[0 0 0],'ycolor',[0 0 0],'Linewidth',1.6,'FontName','Arial','FontSize',12,'FontWeight','bold','tickdir','out','ticklength',[0.04 0.025])
%% figS4.k
clear
load('totaldecodingdata.mat')
cdata=[255 160 64;65 240 174; 24 202 219;36 100 240]/255;
fillcolors=flip(cdata);edgecolor=[0,0,0]; 
data{1}=decording_result{1};data{2}=decording_result{2};
figure('Name','figS4.k')
set(gcf,'unit','centimeters','position',[15 0 16 7.5])
position = [1:1:4];
titlelabel={'Test on uncertain-T1','Test on uncertain-T2'};
for ik=1:2
    subplot(1,2,ik)
    box1= boxplot(data{ik},'positions',position,'colors',edgecolor,'width',0.5,'ExtremeMode','compress','notch','on','symbol','');
    boxobj = findobj(gca,'Tag','Box');
    for j=1:4
        patch(get(boxobj(j),'XData'),get(boxobj(j),'YData'),fillcolors(j,:),'FaceAlpha',0.5);
    end
    box off
    xlim([0.5,4.5]),ylim([60,115]),xticks([1:1:4]),yticks([60:10:100]),xticklabels={'I','II','III','IV'};
    xlabel('Classifier');ylabel('Classification Accuracy (%)');title(titlelabel{ik})
    set(gca,'color','none','xcolor',[0 0 0],'ycolor',[0 0 0],'Linewidth',1.6,'FontName','Arial','FontSize',12,'FontWeight','bold','tickdir','out','ticklength',[0.04 0.025])
end
