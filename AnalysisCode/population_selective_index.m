clear
stable=load('stable.mat');uncertain=load('uncertain.mat');reverse=load('reverse.mat');restable=load('restable.mat');
shSI=[{nan(493,1000)} {nan(493,1000)} {nan(493,1000)} {nan(493,1000)}];
for i=1:493
    go=[stable.population.goHit.eachDF{i}(46:90,:) stable.population.goMiss.eachDF{i}(46:90,:)];
    goR{1}=mean(go(16:end,:),'omitnan');number_go{1}=length(go);
    nogo=[stable.population.nogoCR.eachDF{i}(46:90,:) stable.population.nogoFA.eachDF{i}(46:90,:)];
    nogoR{1}=mean(nogo(16:end,:),'omitnan');
    total{1}=[goR{1} nogoR{1}];
    go=[uncertain.population.goHit.eachDF{i}(46:90,:) uncertain.population.goMiss.eachDF{i}(46:90,:) uncertain.population.RO.eachDF{i}(46:90,:)];
    goR{2}=mean(go(16:end,:),'omitnan');number_go{2}=length(go);
    nogo=[uncertain.population.nogoCR.eachDF{i}(46:90,:) uncertain.population.nogoFA.eachDF{i}(46:90,:)];
    nogoR{2}=mean(nogo(16:end,:),'omitnan');
    total{2}=[goR{2} nogoR{2}];
    go=[reverse.population.goHit.eachDF{i}(46:90,:) reverse.population.goMiss.eachDF{i}(46:90,:)];
    goR{3}=mean(go(16:end,:),'omitnan');number_go{3}=length(go);
    nogo=[reverse.population.nogoCR.eachDF{i}(46:90,:) reverse.population.nogoFA.eachDF{i}(46:90,:)];
    nogoR{3}=mean(nogo(16:end,:),'omitnan');
    total{3}=[goR{3} nogoR{3}];
    go=[restable.population.goHit.eachDF{i}(46:90,:) restable.population.goMiss.eachDF{i}(46:90,:)];
    goR{4}=mean(go(16:end,:),'omitnan');number_go{4}=length(go);
    nogo=[restable.population.nogoCR.eachDF{i}(46:90,:) restable.population.nogoFA.eachDF{i}(46:90,:)];
    nogoR{4}=mean(nogo(16:end,:),'omitnan');
    total{4}=[goR{4} nogoR{4}];
    SI(i,1)=(mean(goR{1},'omitnan')-mean(nogoR{1},'omitnan'))/(std(total{1},'omitnan'));
    SI(i,2)=(mean(goR{2},'omitnan')-mean(nogoR{2},'omitnan'))/(std(total{2},'omitnan'));    
    SI(i,3)=(mean(goR{3},'omitnan')-mean(nogoR{3},'omitnan'))/(std(total{3},'omitnan'));     
    SI(i,4)=(mean(goR{4},'omitnan')-mean(nogoR{4},'omitnan'))/(std(total{4},'omitnan'));
     for j=1:1000
         for ik=1:4
             idx = randperm(size(total{ik},2));
             shft1 =total{ik}(:,idx);%对trial排序打乱处理
             go_sf{ik}=shft1(:,1:number_go{ik});
             nogo_sf{ik}=shft1(:,number_go{ik}+1:end);
             shSI{ik}(i,j)=(mean(go_sf{ik},'omitnan')-mean(nogo_sf{ik},'omitnan'))/(std(total{ik},'omitnan'));
         end
    end
end
[t,tb1,stats]=kruskalwallis(SI,[],'off');
c = multcompare(stats,'CType','bonferroni','display','off')
for i=1:4
   [P(i,1),~,s]=signrank(SI(:,i));
   Z(i,:)=s.zval ; 
end
j=ones(4,3);sig=cell(4,3);
for i=1:493
    for k=1:4
        n=length(find(shSI{k}(i,:)>SI(i,k)));
        m=length(find(shSI{k}(i,:)<SI(i,k)));
        if SI(i,k)>0 && n<=50 %p<0.05
            go_P{k}(j(k,1),:)=i;
            sig{k,1}(j(k),1)=SI(i,k);
            j(k,1)=j(k,1)+1;
        end
        if SI(i,k)<0 && m<=50 %p<0.05
            nogo_P{k}(j(k,2),:)=i;
            sig{k,2}(j(k,2),1)=SI(i,k);
            j(k,2)=j(k,2)+1;
        end
        if (SI(i,k)>0 && n>50) || (SI(i,k)<0 && m>50) 
            non_P{k}(j(k,3),:)=i;
            sig{k,3}(j(k,3),1)=SI(i,k);
            j(k,3)=j(k,3)+1;
        end
    end
end

a1=go_P{1};a2=go_P{2};a3=go_P{3};a4=go_P{4};% positive SI neuron,perfer go cue
b1=nogo_P{1};b2=nogo_P{2};b3=nogo_P{3};b4=nogo_P{4};% negetive SI neuron,perfer nogo cue
c1=non_P{1};c2=non_P{2};c3=non_P{3};c4=non_P{4};% non perfer nogo cue
Constistent{1}=[intersect(a1,a2);intersect(b1,b2)] ;
Constistent{2}=[intersect(a2,a3);intersect(b2,b3)] ;
Constistent{3}=[intersect(a3,a4);intersect(b3,b4)] ;
Constistent{4}=[intersect(a1,a4);intersect(b1,b4)];
Switch{1}=[intersect(a1,b2);intersect(b1,a2)] ;
Switch{2}=[intersect(a2,b3);intersect(b2,a3)] ;
Switch{3}=[intersect(a3,b4);intersect(b3,a4)] ;
Switch{4}=[intersect(a1,b4);intersect(b1,a4)];
Gain{1}=[intersect(c1,a2);intersect(c1,b2)] ;
Gain{2}=[intersect(c2,a3);intersect(c2,b3)] ;
Gain{3}=[intersect(c3,a4);intersect(c3,b4)] ;
Gain{4}=[intersect(c1,a4);intersect(c1,b4)];
Lost{1}=[intersect(c2,a1);intersect(c2,a1)] ;
Lost{2}=[intersect(c3,a1);intersect(c3,b2)] ;
Lost{3}=[intersect(c4,a3);intersect(c4,b3)] ;
Lost{4}=[intersect(c4,a1);intersect(c4,b1)];
for i=1:4
   cell_track(i,:)=[length(Constistent{i}) length(Switch{i}) length(Gain{i}) length(Lost{i})];
end
save('selective_index','sig','SI','shSI','go_P','nogo_P','non_P','cell_track')
