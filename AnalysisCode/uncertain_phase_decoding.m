%first download and add the Neural Decoding Toolbox (NDT) :http://www.readout.info/downloads/
%Meyers, E. (2013). The Neural Decoding Toolbox. Frontiers in Neuroinformatics, 7:8
%%phase decoding
clear
load('uncertain_valuecell_identify.mat')
for i=1:549
data{i}=[mean(gocue.earlyDF{i}(16:45,:),'omitnan')';mean(gocue.lateDF{i}(16:45,:),'omitnan')'];
s=[ones(size(mean(gocue.earlyDF{i}(16:45,:),'omitnan'),2),1)*1;ones(size(mean(gocue.lateDF{i}(16:45,:),'omitnan'),2),1)*2];
n=length(s);
stimulus_ID{i}=cell(1,n);
for ii=1:n
    if s(ii,:)==1
        stimulus_ID{i}{ii}='early';
    else 
        stimulus_ID{i}{ii}='late';
    end
end
end
save('phase_data','stimulus_ID','data')
%%
clear
load('uncertain_outcomecell_identify.mat')
load('uncertain_valuecell_identify.mat')
load('phase_data')
totalcell=[1:549];
result=nan(1000,2);mergecell=intersect(outcome.cell,value.cell);
delte_merge=setdiff(totalcell,mergecell);
 add_ndt_paths_and_init_rand_generator
for i=1:1000
    c1=randsample(totalcell,200);%bootstrape
    binned_data=data(c1);
    binned_labels.stimulus_ID=stimulus_ID(c1);
    load('binned_site_info.mat')
    save('phasedecoding1','binned_data','binned_labels','binned_site_info')
    ds = basic_DS('phasedecoding1','stimulus_ID', 5);
    ds.randomly_shuffle_labels_before_running=0;
    cl =libsvm_CL;
    fps{1} = zscore_normalize_FP;
    cv = standard_resample_CV(ds, cl, fps);
    cv.num_resample_runs = 100;
    cv.display_progress.zero_one_loss = 0;
    cv.test_only_at_training_times = 1;
    datasource = cv.datasource;
    feature_preprocessors = cv.feature_preprocessors;
    classifier = cv.classifier;
    test_only_at_training_times = cv.test_only_at_training_times;
    minimum_resample_runs_executed_and_results_have_converged = 0;
    DECODING_RESULTS = cv.run_cv_decoding;
    result(i,1) = DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.mean_decoding_results *100;
    c2=randsample(delte_merge,200);
    binned_data=data(c2);
    binned_labels.stimulus_ID=stimulus_ID(c2);
    save('phasedecoding2','binned_data','binned_labels','binned_site_info')
    ds = basic_DS('phasedecoding2','stimulus_ID', 5);
    ds.randomly_shuffle_labels_before_running=0;
    cl =libsvm_CL;
    fps{1} = zscore_normalize_FP;
    cv = standard_resample_CV(ds, cl, fps);
    cv.num_resample_runs = 100;
    cv.display_progress.zero_one_loss = 0;
    cv.test_only_at_training_times = 1;
    datasource = cv.datasource;
    feature_preprocessors = cv.feature_preprocessors;
    classifier = cv.classifier;
    test_only_at_training_times = cv.test_only_at_training_times;
    minimum_resample_runs_executed_and_results_have_converged = 0;
    DECODING_RESULTS = cv.run_cv_decoding;
    result(i,2) = DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.mean_decoding_results *100;
end
save('phasedecodingresult','result')