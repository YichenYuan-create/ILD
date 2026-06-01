

rois   = {'AC','SMG','PCG', 'AG', 'MFG', 'BA', 'BP', 'ACC', 'New', 'All' };
hemis  = {'Left', 'Right'};
models = {'ILD', 'ILD_originallog', 'ILD_log_ggfit', 'dBRightMonotonic_linear', 'dBRightMonotonic_log', 'dBLeftMonotonic_linear', 'dBLeftMonotonic_log', 'dBWeighted_linear', 'dBWeighted_log'};

oldName = 'EvenMovBintest2';
newName = 'EvenMovingBinaural';
oldName = 'OddMovBintest2';
newName = 'OddMovingBinaural';
oldName = 'MovBintest3';
newName = 'MovingBinaural';

for r = 1:numel(rois)
    for h = 1:numel(hemis)
        for m = 1:numel(models)

            roi   = rois{r};
            hemi  = hemis{h};
            model = models{m};

            if isfield(dataS01, roi) && ...
               isfield(dataS01.(roi), hemi) && ...
               isfield(dataS01.(roi).(hemi), model) && ...
               isfield(dataS01.(roi).(hemi).(model), oldName)

                dataS01.(roi).(hemi).(model).(newName) = ...
                    dataS01.(roi).(hemi).(model).(oldName);

                dataS01.(roi).(hemi).(model) = ...
                    rmfield(dataS01.(roi).(hemi).(model), oldName);
            end
        end
    end
end

save('dataS01.mat','dataS01');

%Get drawn ROIs
%Line ROI
% meshROI2Volume([], 2); VOLUME{1}.ROIs(VOLUME{1}.selectedROI) = roiSortLineCoords(VOLUME{1});VOLUME{1}=editROIFields(VOLUME{1}); setROIPopup(VOLUME{1});
% %Filled ROI
% meshROI2Volume([], 2); VOLUME{1}=editROIFields(VOLUME{1}); setROIPopup(VOLUME{1});

n_nan  = sum(isnan(tSeries_new(:)));
n_zero = sum(tSeries_new(:) == 0);
n_both = sum(isnan(tSeries_new) | tSeries_new == 0);

n_nan2  = sum(isnan(tSeries(:)));
n_zero2 = sum(tSeries(:) == 0);
n_both2 = sum(isnan(tSeries) | tSeries == 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load all data
close all;
clear;
clc;

% add path
addpath('/media/harveylab/500GB/Yichen/Code');
addpath('/media/harveylab/500GB/Yichen/Code/made_by_Yichen');
paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';


% global variables
baseSubjectOrder=["dataS01", "dataS13", "dataS14", "dataS15", "dataS18", "dataS19", "dataS20", "dataS21"]; 
%Changing part of each ROI name
baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "IFGA", "IFGP", "ACC", "PC"];
% baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "BA", "BP", "ACC", "New"];
mapNames=[baseMapNames(1:2) baseMapNames(4) baseMapNames(3) baseMapNames(9) baseMapNames(5) baseMapNames(6:8)];%, "All"];
% Models
baseModelNames=["ILD", "ILD_HRF", "ILD_log", "ILD_log_ggfit", "ILD_originallog", "ILD_Mirrored", "ILD_Mirrored_Log", "ILD_Mirrored_originalLog", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];

hemispheres={'Left', 'Right'};


%% DTs
cd(paths{1});
mrVista 3
% for sub01 13 14 15 18
DTs=[4 7 10 13 16 19]; 
DTsOdd=[5 8 11 15 17 20];
DTsEven=[6 9 12 14 18 21];
DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);

for i=1:length(DTsAll)
    baseDTnames(i)=convertCharsToStrings(dataTYPES(DTsAll(i)).name);
end
close all

baseDir = '/media/harveylab/500GB/Yichen/Data/data_to_load_new_CV2';
SubsAll = [1 2 3 4 5 6 7 8];
dataTypes = baseDTnames(1:3:end);
subjIDs = baseSubjectOrder(SubsAll);
allData = loadalldata(baseDir, dataTypes, subjIDs);


%% MODEL COMPARISONS

opts = struct();
opts.condition = 'MovingBinaural'; % 'AllBinaural'; 'MovingBinaural'; 'StaticBinaural', 'Monaural'; '  
opts.includeAC = true;
opts.baseSubjectOrder = baseSubjectOrder;
opts.baseDTnames = baseDTnames;
opts.baseModelNames = baseModelNames;
opts.mapNames = mapNames;
opts.hemispheres = hemispheres;
opts.modelIdx=[ 9 10 15 16 1 5];
opts.ModelNamesFig=["Compressive Monotonic", "Log Compressive Monotonic", "Compressive Weighted", "Log Compressive Weighted", "Gaussian", "Log Gaussian"];
opts.expfig = false;

ModelCompareResults = runCompareILDModelFits(allData, opts);
% writematrix(ModelCompareResults.pvals, 'model_comp_pvals_withAC.xlsx')
% writematrix(ModelCompareResults.tMatrix, 'model_comp_tMatrix_withAC.xlsx')
% writematrix(ModelCompareResults.dMatrix, 'model_comp_dMatrix_withAC.xlsx')
save('ModelCompareResults_withAC.mat','ModelCompareResults');


for i = 1:9
    tmp = squeeze(ModelCompareResults.barDataMeans(:,i,:,:,6));
    mean_loggaussian(i) = mean(tmp(:));
    se_loggaussian(i) =  std(tmp(:)) / sqrt(length(tmp(:)));
    tmp2 = squeeze(ModelCompareResults.barDataMeans(:,i,:,:,4));
    mean_logweighted(i) = mean(tmp2(:));
    se_logweighted(i) =  std(tmp2(:)) / sqrt(length(tmp2(:)));

end

if opts.includeAC
    mapNames(5) = "PC";
else
    mapNames(4) = "PC";
end
CompareModel = [ 6 4]; % based on modelNames   ILD_log vs log weighted
opts = struct();
opts.condition = 'MovingBinaural'; % 'AllBinaural'; 'MovingBinaural'; 'StaticBinaural'; 'Monaural'  
[whichSubs, dtsPerSub, veThresh, ~] = getConditionSettings(opts.condition);
opts.includeAC = true;
opts.baseSubjectOrder = baseSubjectOrder(whichSubs);
opts.doExport = false;
opts.ModelNamesFig=["Compressive Monotonic", "Log Compressive Monotonic", "Compressive Weighted", "Log Compressive Weighted", "Gaussian", "Log Gaussian"];
if opts.includeAC
    opts.map = mapNames(1:end);
else
    opts.map = mapNames(2:end);
end

postResults = CompareILDModelpost( ...
    ModelCompareResults.barDataMeans, ...
    opts.baseSubjectOrder, ...
    opts.map, ...
    CompareModel(1), ...
    CompareModel(2),...
    opts.ModelNamesFig,...
    opts);
save('postResults_withAC.mat','postResults');

for i = 1:9
    tmp3 = squeeze(postResults.TunedMonoDif(:,i,:,:));
    mean_diff(i) = mean(tmp3(:));
    se_mean_diff(i) =  std(tmp3(:)) / sqrt(length(tmp3(:)));
end


%% group data across participants
% get data
[whichSubs, dtsPerSub, veThresh, whichDT] = getConditionSettings(opts.condition);
dtsPerSub=dtsPerSub(whichSubs);
dataType = baseDTnames(dtsPerSub);
subjID = baseSubjectOrder(whichSubs);
for i = 1:length(subjID)
    subj = subjID(i);
    data = allData.(dataType{i}).(subjID{i});
    eval([char(subj) ' = data;']);
    clear data;
end

% % group data across participants
% if strcmp(opts.condition, 'AllBinaural')
%     subjID2=subjID([4 6 7 8]);
%     roiList = {'AC', 'SMG', 'PCG', 'AG', 'MFG', 'BA', 'BP', 'ACC', 'New', 'All'};   % rois
%     renameMap = {
%         'MovingBinaural',    'AllAllBinaural';
%         'OddMovingBinaural', 'OddAllBinaural';
%         'EvenMovingBinaural','EvenAllBinaural';
%         'StaticBinaural',    'AllAllBinaural';
%         'OddStaticBinaural', 'OddAllBinaural';
%         'EvenStaticBinaural','EvenAllBinaural'
%     };
%     dataS15old=dataS15;
%     dataS19old=dataS19;
%     dataS20old=dataS20;
%     dataS21old=dataS21;
% 
%     for i = 1:length(subjID2)
%         subjName = subjID2(i);
%         subjName = char(subjName);
%         % read in
%         S = eval(subjName);
%         % use function
%         S = renameMovingToAllall(S, roiList, renameMap);
%         % change name
%         eval([subjName ' = S;']);
%     end
% end

mapNames   = baseMapNames;
modelNames=baseModelNames;
DTnames=baseDTnames; % 7 for moving; 4 for static; 10 for monaural; 1 for allbinaural
for thisSub=whichSubs
    %for each subj, load dataS.mat first
    thisData=char(baseSubjectOrder(thisSub));
    UniteROIsubsILD;
end
allData.dataAllSub = dataAllSub;
mapNames=[baseMapNames(1:2) baseMapNames(4) baseMapNames(3) baseMapNames(9) baseMapNames(5) baseMapNames(6:8)];%, "All"];


opts.condition = 'MovingBinaural'; % 'AllBinaural'; 'MovingBinaural'; 'StaticBinaural', 'Monaural'; '  
subjectDataStruct = struct();
subjectDataStruct.dataS01 = dataS01;
subjectDataStruct.dataS13 = dataS13;
subjectDataStruct.dataS14 = dataS14;
subjectDataStruct.dataS18 = dataS18;
if strcmp(opts.condition, 'MovingBinaural')
    subjectDataStruct.dataS19 = dataS19;
    subjectDataStruct.dataS20 = dataS20;
    subjectDataStruct.dataS21 = dataS21;
    subjectDataStruct.dataAllSub = dataAllSub;
elseif strcmp(opts.condition, 'AllBinaural')
    subjectDataStruct.dataS15 = dataS15;
    subjectDataStruct.dataS19 = dataS19;
    subjectDataStruct.dataS20 = dataS20;
    subjectDataStruct.dataS21 = dataS21;
    subjectDataStruct.dataAllSub = dataAllSub;
elseif strcmp(opts.condition, 'StaticBinaural')
    subjectDataStruct.dataS15 = dataS15;
    subjectDataStruct.dataAllSub = dataAllSub;
elseif strcmp(opts.condition, 'Monaural')
    subjectDataStruct.dataS15 = dataS15;
    subjectDataStruct.dataAllSub = dataAllSub;
end

%% ILD preference
% cd('/media/harveylab/500GB/Yichen/Code');
cd('/media/harveylab/500GB/Yichen/fig')
opts.condition = 'MovingBinaural'; % 'AllBinaural'; 'MovingBinaural'; 'StaticBinaural', 'Monaural'; '  
[~, ~, veThresh, whichDT] = getConditionSettings(opts.condition);

opts_ILD = struct();
opts_ILD.whichSub = "dataAllSub";
opts_ILD.whichModel = 4; % in baseModelNames
opts_ILD.scale = 'log';   % 'lin' or 'log'

opts_ILD.baseMapNames = baseMapNames;
opts_ILD.hemispheres = hemispheres;
opts_ILD.baseModelNames = baseModelNames;
opts_ILD.baseDTnames = baseDTnames;
opts_ILD.whichDT = whichDT; % 1=allbinaural 4=static 7=moving 10=monaural
opts_ILD.veThresh = veThresh;
opts_ILD.vesPlot = false;
opts_ILD.exp = false;

runILDPreferencePlots(allData, opts_ILD);


%% ILD repeatability
opts.condition = 'MovingBinaural'; % 'AllBinaural'; 'MovingBinaural'; 'StaticBinaural'; 'Monaural'  
[whichSubs, dtsPerSub, ~, whichDT] = getConditionSettings(opts.condition);

opts = struct();
opts.baseSubjectOrder = baseSubjectOrder;
opts.baseMapNames = baseMapNames;
opts.baseDTnames = baseDTnames;
opts.baseModelNames = baseModelNames;

opts.hemispheres = hemispheres;
opts.whichDT = [whichDT whichDT+1 whichDT+2];
opts.subjectOrder = baseSubjectOrder;
opts.whichSubs = whichSubs;
opts.mapNames = [baseMapNames(1:2) baseMapNames(4) baseMapNames(3) ...
                 baseMapNames(9) baseMapNames(5) baseMapNames(6:8)];

opts.modelNames = baseModelNames;
opts.whichModel = 5;
opts.scale = 'lin';

opts.whichPlots = [0 0 0 0 0 0 0];
opts.veThresh_stats = 0.1;

opts.mapNames_plot = ["Auditory cortex", "Supramarginal gyrus", ...
    "Angular gyrus", "Postcentral gyrus", "Precuneus", ...
    "Middle frontal gyrus", "Inferior frontal gyrus anterior", ...
    "Inferior frontal gyrus posterior", "Anterior cingulate cortex"];

opts.violinOpts = struct();
opts.violinOpts.doExport = true;
opts.violinOpts.figname = 'repeatability_r_ve0.1.pdf';
opts.violinOpts.contentType = 'vector';
opts.violinOpts.ylim = [-0.5 0.5];
opts.violinOpts.xstep = 1;
opts.violinOpts.ystep = 0.5;
opts.violinOpts.plotyequal0 = true;

results_ILDRepeatability = runILDRepeatabilityAnalysis(subjectDataStruct, opts);

writematrix(results_ILDRepeatability.separatepValues, 'pValslin.xlsx')
writematrix(results_ILDRepeatability.separateRValues, 'rValslin.xlsx')
writematrix(results_ILDRepeatability.separatenValues, 'nValslin.xlsx')
save('ILDRepeatability_plot.mat','results_ILDRepeatability');

% statistic
opts = struct();
opts.doLME = true;
opts.doClassicalANOVA = true;
opts.doSignrank = true;
opts.doFDR = true;
rVals=results_ILDRepeatability.separateRValues;
statsResults = runILDRepeatabilityStats(rVals, baseSubjectOrder, mapNames, opts);
save('ILDRepeatability_statsResults.mat','statsResults');

mean(statsResults.signrank.rdata)
se_iqrILD =  std(statsResults.signrank.rdata) ./ sqrt(length(statsResults.signrank.rdata));



%% new plot median 
opts = struct();
opts.condition = 'MovingBinaural'; % 'AllBinaural'; 'MovingBinaural'; 'StaticBinaural'; 'Monaural'  
[whichSubs, dtsPerSub, veThresh, whichDT] = getConditionSettings(opts.condition);

opts.baseMapNames = baseMapNames;
opts.baseDTnames = baseDTnames;
opts.baseModelNames = baseModelNames;
opts.hemispheres = hemispheres;
opts.mapNames = mapNames;

opts.whichDT_all = [whichDT whichDT+1 whichDT+2];
opts.veThresh = veThresh;

opts.whichSub = [1 13 14 18 19 20 21];
opts.whichModel = 4;
opts.whichDT_plot = 1;
opts.scale = 'lin';
opts.metricToPlot = 'median';

opts.Range = [-22 22];
opts.EdgeThr = 19;
opts.BinWidth = 1;

opts.plotOpts = struct();
opts.plotOpts.doExport = false;
opts.plotOpts.figname = 'median.pdf';
opts.plotOpts.contentType = 'vector';
opts.plotOpts.ylim = [-25 25];
opts.plotOpts.ystep = 5;
opts.plotOpts.plotyequal0 = true;

results = runILDMedianIQRPlot(allData, opts);
save('ILDMedian_plot.mat','results');

% statistic
dataL = results.dataL;
dataR = results.dataR;
subjectNamesUsed = baseSubjectOrder(whichSubs);   % 或任何 subset
mapNamesUsed = mapNames';

% statsOpts = struct();
% statsOpts.doLME = true;
% statsOpts.includeHemisphereInLME = false;
% statsOpts.doClassicalANOVA = true;
% statsOpts.includeHemisphereInClassicalANOVA = false;
% statsOpts.doSignrank = true;
% statsOpts.doFDR = true;
% statsOpts.metricToPlot = 'median';
% 
% prefStatsResults = runILDMetricStats( ...
%     dataL, dataR, subjectNamesUsed, mapNamesUsed, statsOpts);

statsOpts = struct();
statsOpts.metricName = 'median';
statsOpts.signrankCenter = 0;

medianStats = runILDMetricStats( ...
    dataL, ...
    dataR, ...
    subjectNamesUsed, ...
    mapNamesUsed, ...
    statsOpts);
save('ILDMedian_Stats.mat','medianStats');


% for i = 1:9
%     tmp_medianILD = squeeze(medianStats.data(:,i,:));
%     meidanILD(i) = mean(tmp_medianILD(:));
%     se_meidanILD(i) =  std(tmp_medianILD(:)) / sqrt(length(tmp_medianILD(:)));
% end
mean(medianStats.signrank.rankData)

%% IQR 
opts = struct();
opts.condition = 'MovingBinaural';   % 'AllBinaural'; 'MovingBinaural'; 'StaticBinaural'; 'Monaural'
[whichSubs, dtsPerSub, veThresh, whichDT] = getConditionSettings(opts.condition);

opts.baseMapNames = baseMapNames;
opts.baseDTnames = baseDTnames;
opts.baseModelNames = baseModelNames;
opts.hemispheres = hemispheres;
opts.mapNames = mapNames;

opts.whichDT_all = [whichDT whichDT+1 whichDT+2];
opts.veThresh = veThresh;

opts.whichSub = [1 13 14 18 19 20 21];
opts.whichModel = 4;
opts.whichDT_plot = 1;
opts.scale = 'log';
opts.metricToPlot = 'iqr';
if strcmp(opts.scale,'log')
    opts.Range = [-4 4];
elseif strcmp(opts.scale,'lin')
    opts.Range = [-22 22];
end

opts.plotOpts = struct();
opts.plotOpts.doExport = true;
if strcmp(opts.scale,'log')
    opts.plotOpts.figname = 'IQR_log.pdf';
    opts.plotOpts.ylim = [0 8];
    opts.plotOpts.ystep = 2;
elseif strcmp(opts.scale,'lin')
    opts.plotOpts.figname = 'IQR_lin.pdf';
    opts.plotOpts.ylim = [0 30];
    opts.plotOpts.ystep = 10;
end
opts.plotOpts.contentType = 'vector';
opts.plotOpts.plotyequal0 = false;

res_iqr = runILDMedianIQRPlot(allData, opts);
if strcmp(opts.scale,'log')
    save('iqr_plot_log.mat','res_iqr');
elseif strcmp(opts.scale,'lin')
    save('iqr_plot_lin.mat','res_iqr');
end


% statistic
% dataL = res_iqr.dataL;
% dataR = res_iqr.dataR;
% subjectNamesUsed = string(opts.whichSub);
% mapNamesUsed = mapNames';

statsOpts = struct();
statsOpts.metricName = 'iqr';
statsOpts.signrankCenter = 0;

iqrStats = runILDMetricStats( ...
    res_iqr.dataL, ...
    res_iqr.dataR, ...
    string(opts.whichSub), ...
    mapNames', ...
    statsOpts);
if strcmp(opts.scale,'log')
    save('iqr_Stats_log.mat','iqrStats');
elseif strcmp(opts.scale,'lin')
    save('iqr_Stats_lin.mat','iqrStats');
end
% statsOpts = struct();
% statsOpts.doLME = true;
% statsOpts.includeHemisphereInLME = false;
% statsOpts.doClassicalANOVA = true;
% statsOpts.includeHemisphereInClassicalANOVA = false;
% statsOpts.doSignrank = true;
% statsOpts.doFDR = true;
% statsOpts.metricToPlot = 'iqr';
% 
% iqrStatsResults = runILDMetricStats( ...
%     dataL, dataR, subjectNamesUsed, mapNamesUsed, statsOpts);

% for i = 1:9
%     tmp_iqrILD = squeeze(iqrStats.data(:,i,:));
%     iqrILD(i) = mean(tmp_iqrILD(:));
%     se_iqrILD(i) =  std(tmp_iqrILD(:)) / sqrt(length(tmp_iqrILD(:)));
% end
mean(iqrStats.signrank.rankData)

%% Fit 3 gaussian to all data 
opts = struct();
opts.condition = 'MovingBinaural';
[~, ~, veThresh, whichDT] = getConditionSettings(opts.condition);

opts.whichSub = [1 13 14 18 19 20 21];
opts.whichSubGroup = "dataAllSub";
opts.subjectLevel = true;

opts.baseMapNames = baseMapNames;
opts.baseDTnames = baseDTnames;
opts.baseModelNames = baseModelNames;
opts.mapNames = mapNames;
opts.hemispheres = {'Left','Right'};

opts.whichModel = 4;
opts.whichDT = whichDT;
opts.veThresh = 0.1;
opts.scale = 'log';  % lin or log
opts.balanceN = 1000;
opts.quickPlot_groupGMM = true;
opts.quickPlot = true;
opts.signreverse = true;
if strcmp(opts.scale,'log')
    opts.figname_subj = 'GMM_subj_log.pdf';
    opts.figname = 'GMM_group_log.pdf';
    opts.figname2 = 'GMM_groupROI_log.pdf';
elseif strcmp(opts.scale,'lin')
    opts.figname_subj = 'GMM_subj_lin.pdf';
    opts.figname = 'GMM_group_lin.pdf';
    opts.figname2 = 'GMM_groupROI_lin.pdf';
end
opts.doExport = true;
opts.doExport_groupGMM = true;
opts.contentType = 'vector';

GMMres_subj = fitSubjectILD3GMMContra(allData, opts);
if strcmp(opts.scale,'log')
    save('GMMres_subj_log.mat','GMMres_subj');
elseif strcmp(opts.scale,'lin')
    save('GMMres_subj_lin.mat','GMMres_subj');
end
res_group_lin = fitGroupILD3GMMContra(allData, rmfield(opts,'subjectLevel'));
if strcmp(opts.scale,'log')
    save('GMMres_subj_log.mat','GMMres_subj');
elseif strcmp(opts.scale,'lin')
    save('GMMres_subj_lin.mat','GMMres_subj');
end

weights_ipsi   = squeeze(GMMres_subj.weights(:,:,:,1));
weights_mid    = squeeze(GMMres_subj.weights(:,:,:,2));
weights_contra = squeeze(GMMres_subj.weights(:,:,:,3));
weights_ratio = (weights_contra-weights_ipsi)./(weights_contra+weights_ipsi);
% weights_ipsi(:,:,1)   = squeeze(res_subj_lin.weights(:,:,1,1));
% weights_ipsi(:,:,2)   = squeeze(res_subj_lin.weights(:,:,2,3));
% weights_mid    = squeeze(res_subj_lin.weights(:,:,:,2));
% weights_contra(:,:,1) = squeeze([res_subj_lin.weights(:,:,1,3)]);
% weights_contra(:,:,2) = squeeze([res_subj_lin.weights(:,:,2,1)]);

% plot 
nROI=9;
mapNames_plot=["Auditory cortex", "Supramarginal gyrus", ...
               "Angular gyrus", "Postcentral gyrus", ...
               "Precuneus", "Middle frontal gyrus", ...
               "pars orbitalis", "Pars opercularis", ...
               "Anterior cingulate cortex"];

opts_plot = struct();
opts_plot.whichSub = [1 13 14 18 19 20 21];
opts_plot.doExport = true;
opts_plot.contentType = 'vector';
opts_plot.xlim = [1 nROI];
opts_plot.xstep = 1;
opts_plot.ystep = 0.2;
opts_plot.plotyequal0 = false;
colors = [
    0.894 0.102 0.110
    0.216 0.494 0.722
    0.302 0.686 0.290
    0.596 0.306 0.639
    1.000 0.498 0.000
    1.000 0.749 0.000
    0.651 0.337 0.157
    0.969 0.506 0.749
    0.200 0.200 0.200
];


dataL = weights_contra(:,:,1);
dataR = weights_contra(:,:,2);
[nSub, ~] = size(dataL);
if strcmp(opts.scale,'log')
    opts_plot.figname = 'WeightContra_log.pdf';
elseif strcmp(opts.scale,'lin')
    opts_plot.figname = 'WeightContra_lin.pdf';
end
if contains(opts_plot.figname, 'Ratio')
    opts_plot.ylim = [-1 1];
else
    opts_plot.ylim = [0 1];
end
Plothalfviolin(dataL, dataR, colors, nROI, nSub, mapNames_plot, opts_plot)

dataL = weights_mid(:,:,1);
dataR = weights_mid(:,:,2);
[nSub, ~] = size(dataL);
if strcmp(opts.scale,'log')
    opts_plot.figname = 'WeightMid_log.pdf';
elseif strcmp(opts.scale,'lin')
    opts_plot.figname = 'WeightMid_lin.pdf';
end
if contains(opts_plot.figname, 'Ratio')
    opts_plot.ylim = [-1 1];
else
    opts_plot.ylim = [0 1];
end
Plothalfviolin(dataL, dataR, colors, nROI, nSub, mapNames_plot, opts_plot)

dataL = weights_ipsi(:,:,1);
dataR = weights_ipsi(:,:,2);
[nSub, ~] = size(dataL);
if strcmp(opts.scale,'log')
    opts_plot.figname = 'WeightIpsi_log.pdf';
elseif strcmp(opts.scale,'lin')
    opts_plot.figname = 'WeightIpsi_lin.pdf';
end
if contains(opts_plot.figname, 'Ratio')
    opts_plot.ylim = [-1 1];
else
    opts_plot.ylim = [0 1];
end
Plothalfviolin(dataL, dataR, colors, nROI, nSub, mapNames_plot, opts_plot)

dataL = weights_ratio(:,:,1);
dataR = weights_ratio(:,:,2);
[nSub, ~] = size(dataL);
if strcmp(opts.scale,'log')
    opts_plot.figname = 'WeightRatio_log.pdf';
elseif strcmp(opts.scale,'lin')
    opts_plot.figname = 'WeightRatio_lin.pdf';
end
if contains(opts_plot.figname, 'Ratio')
    opts_plot.ylim = [-1 1];
else
    opts_plot.ylim = [0 1];
end
Plothalfviolin(dataL, dataR, colors, nROI, nSub, mapNames_plot, opts_plot)



statsOpts = struct();
statsOpts.metricName = 'w_contra';
statsOpts.signrankCenter = 1/3;

contraStats = runILDMetricStats( ...
    weights_contra(:,:,1), ...
    weights_contra(:,:,2), ...
    string(opts_plot.whichSub), ...
    mapNames', ...
    statsOpts);
if strcmp(opts.scale,'log')
    save('contraStats_log.mat','contraStats');
elseif strcmp(opts.scale,'lin')
    save('contraStats_lin.mat','contraStats');
end

statsOpts = struct();
statsOpts.metricName = 'w_mid';
statsOpts.signrankCenter = 1/3;

midStats = runILDMetricStats( ...
    weights_mid(:,:,1), ...
    weights_mid(:,:,2), ...
    string(opts_plot.whichSub), ...
    mapNames', ...
    statsOpts);
if strcmp(opts.scale,'log')
    save('midStats_log.mat','midStats');
elseif strcmp(opts.scale,'lin')
    save('midStats_lin.mat','midStats');
end

statsOpts = struct();
statsOpts.metricName = 'w_ipsi';
statsOpts.signrankCenter = 1/3;

ipsiStats = runILDMetricStats( ...
    weights_ipsi(:,:,1), ...
    weights_ipsi(:,:,2), ...
    string(opts_plot.whichSub), ...
    mapNames', ...
    statsOpts);
if strcmp(opts.scale,'log')
    save('ipsiStats_log.mat','ipsiStats');
elseif strcmp(opts.scale,'lin')
    save('ipsiStats_lin.mat','ipsiStats');
end

statsOpts = struct();
statsOpts.metricName = 'w_contr_ipsi_ratio';
statsOpts.signrankCenter = 0;
ratioStats = runILDMetricStats( ...
    weights_ratio(:,:,1), ...
    weights_ratio(:,:,2), ...
    string(opts_plot.whichSub), ...
    mapNames', ...
    statsOpts);
if strcmp(opts.scale,'log')
    save('ratioStats_log.mat','ratioStats');
elseif strcmp(opts.scale,'lin')
    save('ratioStats_lin.mat','ratioStats');
end

mean(contraStats.signrank.rankData)
se_iqrILD =  std(contraStats.signrank.rankData) ./ sqrt(length(contraStats.signrank.rankData));

mean(midStats.signrank.rankData)
se_iqrILD =  std(midStats.signrank.rankData) ./ sqrt(length(midStats.signrank.rankData));

mean(ipsiStats.signrank.rankData)
se_iqrILD =  std(ipsiStats.signrank.rankData) ./ sqrt(length(ipsiStats.signrank.rankData));

mean(ratioStats.signrank.rankData)
se_iqrILD =  std(ratioStats.signrank.rankData) ./ sqrt(length(ratioStats.signrank.rankData));

%% for tuning sigma
opts = struct();
opts.condition = 'MovingBinaural'; % 'AllBinaural'; 'MovingBinaural'; 'StaticBinaural'; 'Monaural'  
[whichSubs, dtsPerSub, veThresh, whichDT] = getConditionSettings(opts.condition);

opts.baseMapNames = baseMapNames;
opts.baseDTnames = baseDTnames;
opts.baseModelNames = baseModelNames;
opts.hemispheres = hemispheres;
opts.mapNames = mapNames;

opts.whichDT_all = [whichDT whichDT+1 whichDT+2];
opts.veThresh = veThresh;

opts.whichSub = [1 13 14 18 19 20 21];
opts.whichModel = 4;
opts.whichDT_plot = 1;
opts.scale = 'log';
opts.metricToPlot = 'sigma';
opts.plotOpts = struct();
opts.plotOpts.doExport = true;
if strcmp(opts.scale,'log')
    opts.plotOpts.figname = 'sigma_log.pdf';
    opts.plotOpts.ylim = [0 5];
    opts.plotOpts.ystep = 1;
elseif strcmp(opts.scale,'lin')
    opts.plotOpts.figname = 'sigma_lin.pdf';
    opts.plotOpts.ylim = [0 1500];
    opts.plotOpts.ystep = 500;
end
opts.plotOpts.contentType = 'vector';
opts.plotOpts.plotyequal0 = true;

results = runILDMedianIQRPlot(allData, opts);
if strcmp(opts.scale,'log')
    save('sigmaMedian_plot_log.mat','results');
elseif strcmp(opts.scale,'lin')
    save('sigmaMedian_plot_lin.mat','results');
end

% statistic
dataL = results.dataL;
dataR = results.dataR;
subjectNamesUsed = baseSubjectOrder(whichSubs);  
mapNamesUsed = mapNames';

statsOpts = struct();
statsOpts.metricName = 'sigma';
statsOpts.signrankCenter = 0;

medianStats = runILDMetricStats( ...
    dataL, ...
    dataR, ...
    subjectNamesUsed, ...
    mapNamesUsed, ...
    statsOpts);
if strcmp(opts.scale,'log')
    save('sigmaMedian_stats_log.mat','medianStats');
elseif strcmp(opts.scale,'lin')
    save('sigmaMedian_stats_lin.mat','medianStats');
end

mean(medianStats.signrank.rankData)
se_iqrILD =  std(medianStats.signrank.rankData) ./ sqrt(length(medianStats.signrank.rankData));

%% For tuning widths _ILD
opts = struct();
opts.condition = 'MovingBinaural';
[~, ~, veThresh, whichDT] = getConditionSettings(opts.condition);
opts_sigma = struct();
opts_sigma.subjectOrder = [baseSubjectOrder, "dataAllSub"];
opts_sigma.baseSubjectOrder = baseSubjectOrder;
opts_sigma.mapNames = mapNames;
opts_sigma.baseDTnames = baseDTnames;
opts_sigma.modelNames = baseModelNames;

opts_sigma.whichSubs = 9; % all sub
opts_sigma.whichModel = 4; % in basemodelnames
opts_sigma.whichDT = [whichDT whichDT+1 whichDT+2]; % 1 2 3 for all binautal, 4 5 6 for static, 7 8 9 for moving
opts_sigma.veThresh = veThresh;
opts_sigma.whichPlots = [0 0 0 0 0 1 0];
opts_sigma.hemispheres = hemispheres;

opts_sigma.scale = 'log';  % lin or log;

[statsAll,  dataPlotAll] = runILDPlots(subjectDataStruct, opts_sigma);


set(fig1,'PaperPositionMode','auto');
set(fig1,'Renderer','painters');   % best for vector
if strcmp(scale,'lin')
    filename = 'tuningwidth_ILD_lin.pdf';
elseif strcmp(scale,'log')
    filename = 'tuningwidth_ILD_log.pdf';
end
exportgraphics(gcf, filename, ...
    'Append', false, ...
    'ContentType', 'vector');  


if strcmp(opts_sigma.scale,'log')
    save('sigmaILD_plot_log.mat','dataPlotAll');
    save('sigmaILD_stats_log.mat','statsAll');
elseif strcmp(opts_sigma.scale,'lin')
    save('sigmaILD_plot_lin.mat','dataPlotAll');
    save('sigmaILD_stats_lin.mat','statsAll');
end



%% tuning width slope for each participant
opts = struct();
opts.condition = 'MovingBinaural'; % 'AllBinaural'; 'MovingBinaural'; 'StaticBinaural'; 'Monaural'  
[whichSubs, dtsPerSub, veThresh, whichDT] = getConditionSettings(opts.condition);

opts.subjectOrder = baseSubjectOrder(whichSubs);
opts.whichSubs = whichSubs;
opts.subjectNamesUsed = baseSubjectOrder(whichSubs);

opts.mapNames = [baseMapNames(1:2) baseMapNames(4) baseMapNames(3) ...
                 baseMapNames(9) baseMapNames(5) baseMapNames(6:8)];
opts.hemispheres = {'Left','Right'};

opts.baseModelNames = baseModelNames;
opts.baseDTnames = baseDTnames;
opts.whichModel = 4;
opts.whichDT = [whichDT whichDT+1 whichDT+2];
opts.veThresh = veThresh;
opts.whichPlots = [0 0 0 0 0 1 0];
opts.scale = 'lin';
opts.mapNames_plot = ["Auditory cortex", "Supramarginal gyrus", ...
    "Angular gyrus", "Postcentral gyrus", "Precuneus", ...
    "Middle frontal gyrus", "Inferior frontal gyrus anterior", ...
    "Inferior frontal gyrus posterior", "Anterior cingulate cortex"];

% choose which metric from stats_allptc to analyze
opts.metricField = 'BsigMajorMean';
opts.metricCol = 2;
opts.pField = 'PsigMajorMean';

opts.plotOpts = struct();
opts.plotOpts.doExport = true;
opts.plotOpts.figname = 'slope_lin.pdf';
opts.plotOpts.contentType = 'vector';
opts.plotOpts.ylim = [-200 1000];
opts.plotOpts.ystep = 200;
opts.plotOpts.plotyequal0 = true;

opts.statsOpts = struct();
opts.statsOpts.metricName = 'BsigMajorMean_lin';
opts.statsOpts.signrankCenter = 0;

res_tw_lin = runTuningWidthParticipantAnalysis(subjectDataStruct, opts);
save('res_tuningwidthslope_lin','res_tw_lin')

% log space
opts.scale = 'log';
opts.plotOpts.figname = 'slope_log.pdf';
opts.plotOpts.ylim = [-2 2];
opts.plotOpts.ystep = 1;
opts.statsOpts.metricName = 'BsigMajorMean_log';

res_tw_log = runTuningWidthParticipantAnalysis(subjectDataStruct, opts);
save('res_tuningwidthslope_log','res_tw_log')


mean(res_tw_lin.statsRes.signrank.rankData)
se_iqrILD =  std(res_tw_lin.statsRes.signrank.rankData) ./ sqrt(length(res_tw_lin.statsRes.signrank.rankData));

mean(res_tw_log.statsRes.signrank.rankData)
se_iqrILD =  std(res_tw_log.statsRes.signrank.rankData) ./ sqrt(length(res_tw_log.statsRes.signrank.rankData));
