clear
add_ndt_paths_and_init_rand_generator
ds = basic_DS('uncertain2-gonogo','stimulus_ID', 3);
ds1 = basic_DS('uncertain1-gonogo','stimulus_ID', 3);
ds3 = basic_DS('uncertain3-gonogo','stimulus_ID', 3);
ds.randomly_shuffle_labels_before_running=0;
cl =libsvm_CL;
fps{1} = zscore_normalize_FP;
cv = standard_resample_CV(ds, cl, fps);cv1 = standard_resample_CV(ds1, cl, fps);cv3 = standard_resample_CV(ds3, cl, fps);
cv.num_resample_runs = 500;
cv.display_progress.zero_one_loss = 0;
cv.test_only_at_training_times = 1;
datasource = cv.datasource;datasource1 = cv1.datasource;datasource3 = cv3.datasource;
feature_preprocessors = cv.feature_preprocessors;
classifier = cv.classifier;
test_only_at_training_times = cv.test_only_at_training_times;
minimum_resample_runs_executed_and_results_have_converged = 0;

for iResample = 1:cv.num_resample_runs
    
    [all_XTr all_YTr all_XTe all_YTe] = datasource.get_data;
    [all_XTr2 all_YTr2 all_XTe1 all_YTe1] = datasource1.get_data;
    
    [all_XTr2 all_YTr2 all_XTe3 all_YTe3] = datasource3.get_data;
    curr_total_CV_zero_one_loss_results = cell(size(all_XTr, 2), 1);
    curr_total_CV_normalized_rank_results = cell(size(all_XTr, 2), 1);
    curr_total_CV_decision_values_results = cell(size(all_XTr, 2), 1);
    for iCV = 1:size(all_XTr{1}, 2)
        for iTrainingInterval = 1:size(all_XTr, 2)
            % get the data for the current training interval and CV run
            XTr = all_XTr{iTrainingInterval}{iCV};
            if iscell(all_YTr)
                YTr = all_YTr{iTrainingInterval};
            else
                YTr = all_YTr;
            end
            % apply preprocessing to the training data
            if ~isempty(cv.feature_preprocessors)
                for iFP = 1:length(cv.feature_preprocessors)
                    [feature_preprocessors{iFP} XTr] = feature_preprocessors{iFP}.set_properties_with_training_data(XTr, YTr);  % save FP parameters and get normalized XTr
                    % save preprocessing information (if the user has specified that such information should be saved)
                    %  [could make the method get_current_info_to_save as not required in the FP interface,
                    %    by checking to see if a particular FP has this method via methods(the_feature_preprocessors{iFP}),
                    %    but going to keep it a required part of the interface for now]
                    curr_FP_info_to_save = feature_preprocessors{iFP}.get_current_info_to_save;
                    if ~isempty(curr_FP_info_to_save)
                        %field_names = fields(curr_FP_info_to_save);
                        field_names = fieldnames(curr_FP_info_to_save);  % changed this to make the code compartible with Octave
                        for iFieldName = 1:length(field_names)
                            eval(['curr_FP_data_to_save_one_field = curr_FP_info_to_save.' field_names{iFieldName} ';']);
                            if isnumeric(curr_FP_data_to_save_one_field)
                                eval(['DECODING_RESULTS.FP_INFO{iFP}.'  field_names{iFieldName} '(iResample, iCV, iTrainingInterval, :) = curr_FP_data_to_save_one_field;']);    % will have to modify this slightly if returning a matrix, etc..
                            else
                                eval(['DECODING_RESULTS.FP_INFO{iFP}.'  field_names{iFieldName} '{iResample, iCV, iTrainingInterval} = curr_FP_data_to_save_one_field;']);
                            end
                        end
                    end
                end
            end   % end preprocessing training code
            % train the classifier
            classifier = classifier.train(XTr, YTr);
            test_interval = iTrainingInterval;
            % run through each test time bin and evaluate how good the decoding accuracy is
            for iTestInterval = test_interval
                iTestIntervalSaveInd = 1;
                
                % current test data
                XTe = all_XTe{iTestInterval}{iCV};
                if iscell(all_YTe)
                    YTe = all_YTe{iTestInterval};
                else
                    YTe = all_YTe;
                end
                % apply feature preprocessing to the test data
                if ~isempty(cv.feature_preprocessors)
                    for iFP = 1:length(cv.feature_preprocessors)
                        XTe = feature_preprocessors{iFP}.preprocess_test_data(XTe);
                    end
                end
                % test the classifier
                [predicted_labels decision_values] = classifier.test(XTe);
                % store information for creating a confusion matrix
                if cv.confusion_matrix_params.create_confusion_matrix
                    all_predicted_labels_for_confusion_matrix_and_MI(iResample, iCV, :, iTrainingInterval, iTestIntervalSaveInd) = predicted_labels;
                end
                % save the zero-one loss results
                DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS2.decoding_results(iResample, iCV, iTrainingInterval, iTestIntervalSaveInd, :) = ((length(find(predicted_labels - YTe == 0))/length(predicted_labels)));
                % storing stdevs of single 0-1 classifier results
                DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS2.stdev.all_single_CV_vals(iResample, iCV, iTrainingInterval, iTestIntervalSaveInd) = std(~((predicted_labels - YTe) == 0));   % can also be calculated analytically from decoding_results using p(1-p) binomial variance formula
                curr_total_CV_zero_one_loss_results{iTrainingInterval,iTestIntervalSaveInd} = [curr_total_CV_zero_one_loss_results{iTrainingInterval,iTestIntervalSaveInd}; ~((predicted_labels - YTe) == 0)];
                
                
                % test uncertain1 data
                XTe1 = all_XTe1{iTestInterval}{iCV};
                if iscell(all_YTe1)
                    YTe1 = all_YTe1{iTestInterval};
                else
                    YTe1 = all_YTe1;
                end
                % apply feature preprocessing to the test data
                if ~isempty(cv.feature_preprocessors)
                    for iFP = 1:length(cv.feature_preprocessors)
                        XTe1 = feature_preprocessors{iFP}.preprocess_test_data(XTe1);
                    end
                end
                % test the classifier
                [predicted_labels decision_values] = classifier.test(XTe1);
                % store information for creating a confusion matrix
                if cv.confusion_matrix_params.create_confusion_matrix
                    all_predicted_labels_for_confusion_matrix_and_MI(iResample, iCV, :, iTrainingInterval, iTestIntervalSaveInd) = predicted_labels;
                end
                % save the zero-one loss results
                DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS1.decoding_results(iResample, iCV, iTrainingInterval, iTestIntervalSaveInd, :) = ((length(find(predicted_labels - YTe1 == 0))/length(predicted_labels)));
                % storing stdevs of single 0-1 classifier results
                DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS1.stdev.all_single_CV_vals(iResample, iCV, iTrainingInterval, iTestIntervalSaveInd) = std(~((predicted_labels - YTe1) == 0));   % can also be calculated analytically from decoding_results using p(1-p) binomial variance formula
                curr_total_CV_zero_one_loss_results{iTrainingInterval,iTestIntervalSaveInd} = [curr_total_CV_zero_one_loss_results{iTrainingInterval,iTestIntervalSaveInd}; ~((predicted_labels - YTe1) == 0)];
                
                
                % test uncertain3 data
                XTe3 = all_XTe3{iTestInterval}{iCV};
                if iscell(all_YTe3)
                    YTe3 = all_YTe3{iTestInterval};
                else
                    YTe3 = all_YTe3;
                end
                % apply feature preprocessing to the test data
                if ~isempty(cv.feature_preprocessors)
                    for iFP = 1:length(cv.feature_preprocessors)
                        XTe3 = feature_preprocessors{iFP}.preprocess_test_data(XTe3);
                    end
                end
                % test the classifier
                [predicted_labels decision_values] = classifier.test(XTe3);
                % store information for creating a confusion matrix
                if cv.confusion_matrix_params.create_confusion_matrix
                    all_predicted_labels_for_confusion_matrix_and_MI(iResample, iCV, :, iTrainingInterval, iTestIntervalSaveInd) = predicted_labels;
                end
                % save the zero-one loss results
                DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS3.decoding_results(iResample, iCV, iTrainingInterval, iTestIntervalSaveInd, :) = ((length(find(predicted_labels - YTe3 == 0))/length(predicted_labels)));
                % storing stdevs of single 0-1 classifier results
                DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS3.stdev.all_single_CV_vals(iResample, iCV, iTrainingInterval, iTestIntervalSaveInd) = std(~((predicted_labels - YTe3) == 0));   % can also be calculated analytically from decoding_results using p(1-p) binomial variance formula
                curr_total_CV_zero_one_loss_results{iTrainingInterval,iTestIntervalSaveInd} = [curr_total_CV_zero_one_loss_results{iTrainingInterval,iTestIntervalSaveInd}; ~((predicted_labels - YTe3) == 0)];
                
                
            end  % end for the test time periods
        end  % end for the train time periods
    end
end

DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS1.mean_decoding_results = squeeze(mean(mean(DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS1.decoding_results*100, 2), 1));
DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS1.stdev.over_resamples = squeeze(std(mean(DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS1.decoding_results*100, 2), [], 1));
DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS2.mean_decoding_results = squeeze(mean(mean(DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS2.decoding_results*100, 2), 1));
DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS2.stdev.over_resamples = squeeze(std(mean(DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS2.decoding_results*100, 2), [], 1));
DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS3.mean_decoding_results = squeeze(mean(mean(DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS3.decoding_results*100, 2), 1));
DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS3.stdev.over_resamples = squeeze(std(mean(DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS3.decoding_results*100, 2), [], 1));
save('uncetrain2_result','DECODING_RESULTS')
