% Define the folder path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% !!!WARNING!!!
% running this script will overwrite some of the original files
% be 100% sure before running it
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the folder path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% !!!WARNING!!!
% running this script will overwrite some of the original files
% be 100% sure before running it
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Step 2: from log to lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% !!!WARNING!!!
% running this script will overwrite some of the original files
% be 100% sure before running it
% also should always run step 1 first then 2 (not always..., so check)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear;
clc;

rootFolder0{1} = '/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession/Gray';

for root = 1:1
    rootFolder = rootFolder0{root};


    % Get all subfolders in the root folder
    folderInfo = dir(rootFolder);
    subfolders = folderInfo([folderInfo.isdir] & ~startsWith({folderInfo.name}, '.') & ~strcmp({folderInfo.name}, 'ROIs'));
    
    for i = 1:length(subfolders)
        subfolderName = subfolders(i).name;
        
        % Skip '.', '..', and folders containing 'Original' or 'OI'
        if ~contains(subfolderName, 'Validation', 'IgnoreCase', true) || (contains(subfolderName, 'Validation', 'IgnoreCase', true) && contains(subfolderName, 'Mirror', 'IgnoreCase', true))
            fprintf('⏩ Skipping folder: %s\n', subfolderName);
            continue;
        end
        
        folderPath = fullfile(rootFolder, subfolderName);
        backupPath = fullfile(folderPath, 'original_model_output_backup_before_log2lin');
        if ~exist(backupPath, 'dir')
            mkdir(backupPath);
        end

        fileList1 = dir(fullfile(folderPath, 'retModel-1DGaussian-*ILD-Log*.mat'));
        % fileList2 = dir(fullfile(folderPath, 'retModel-*Mirrored*-Log*.mat'));
        % fileList = [fileList1; fileList2];
        fileList = fileList1;


        fprintf('\n📁 Processing folder: %s\n', subfolderName);
    
        % if length(fileList)==2
        if length(fileList)==1
    %         for k = 3
            for k = 1:length(fileList)
                % Get current file name and full path
                currentFile = fileList(k).name;
                originalPath = fullfile(folderPath, currentFile);
                backupFilePath = fullfile(backupPath, currentFile);
                
                % Copy to backup
                copyfile(originalPath, backupFilePath);
                fprintf('Backed up: %s\n', currentFile);  
            end
            for k = 1:length(fileList)
                currentFile = fileList(k).name;
                originalPath = fullfile(folderPath, currentFile);
                backupFilePath = fullfile(backupPath, currentFile);
                if ~contains(currentFile, 'original')
                    % Load the model
                    fprintf('Loading: %s\n', currentFile);
                    load(originalPath);
                    
                    % --- Your modification code goes here ---
                    fwhms=model{1}.sigma.major.*(2*sqrt(2*log(2)));
                    
                    fwhms=sinh(model{1}.x0+fwhms./2)-sinh(model{1}.x0-fwhms./2); 
                    model{1}.sigma.major=fwhms;
                    model{1}.sigma.minor=fwhms;
                    
                    
                    if isfield(model{1}, 'sigma2')
                        fwhms2=model{1}.sigma2.major.*(2*sqrt(2*log(2)));
                        fwhms2=exp(model{1}.x0+fwhms2./2)-exp(model{1}.x0-fwhms2./2);
                        model{1}.sigma2.major=fwhms2;
                        model{1}.sigma2.minor=fwhms2;
                    end
                    % latest should be this
                    model{1}.x0=sinh(model{1}.x0);

                   
                    % Create new filename by appending '_modified' before .mat
                    [~, nameOnly, ~] = fileparts(currentFile);
                    newFileName = [nameOnly '.mat'];
                    newFilePath = fullfile(folderPath, newFileName);
                    
                    % Save the modified model
                    fprintf('Saving to: %s\n', newFileName);
            %         eval([varName{1} ' = model;']);
                    save(newFilePath, 'model','params');
                    
                    % move the backup original model back to the main
                    % folder, changing name to "original"
                    oldName = currentFile;
                    newName = strrep(oldName, 'Log', 'originalLog');
                    originalPath1 = fullfile(backupPath, oldName);            
                    originalPath11 = fullfile(folderPath, newName);            
                    movefile(originalPath1, originalPath11);




                end
            end
            fprintf('All models processed and saved.\n');
        else
            fprintf('Warning! model number ~= 14.\n');
        end
    end
end




%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Step 4: move file to xval
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% !!!WARNING!!!
% running this script will overwrite some of the original files
% be 100% sure before running it
% also should always run step 1 first then 2 then 3 then 4 (not always..., so check)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



close all;
clear;
clc;


paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';



% Following the order above, define simpler names
baseSubjectOrder=["dataS01"]; 
subjectOrder=baseSubjectOrder;
for  whichSubs=1:1
    baseMapNames=["AC", "SMG", "PCG", "AG", "MFG", "BA", "BP", "ACC", "New"];
    % modelNames{1}=["ILD", "ILD_HRF", "ILD_log", "ILD_log_HRF", "ILD_originallog", "ILD_Mirrored", "ILD_Mirrored_originallog", "dBRightMonotonic_linear", "dBRightMonotonic_log", "dBLeftMonotonic_linear", "dBLeftMonotonic_log", "dBBalance_linear", "dBBalance_log", "dBWeighted_linear", "dBWeighted_log"];
    % modelFileNames{1}=["retModel-*Monotonic*Left*", "retModel-*Monotonic*Right*",...
    %     "retModel-*ILD-Linear*", "retModel-*n-DT0.5-ILD-Log*",...
    %     "retModel-*ILD-originalLog*", "retModel-*Mirrored*-ILD-Log*",...
    %     "retModel-*Weighted*", "retModel-*Mirrored*-ILD-originalLog*"];
    modelNames{1}=["ILD_Mirrored", "ILD_Mirrored_originallog", "dBWeighted_log"];
    modelFileNames{1}=["retModel-*Mirrored*-ILD-Log*",...
        "retModel-*Weighted*", "retModel-*Mirrored*-ILD-originalLog*"];
    baseModelNames=["*n-DT0.5-ILD-Linear*gFit*",...
    "*n-DT0.5-ILD-Log*-gFit*", "*n-DT0.5-ILD-originalLog*-gFit*",...
    "*1DCompressiveMonotonic-DT0.5-dBRight-Log*", ...
    "*1DCompressiveMonotonic-DT0.5-dBLeft-Log*", ...
    "*1DCompressiveWeighted-DT0.5-dB-Log*"];
    modelFileNames{1}=baseModelNames;
    % sub01
    cd(paths{whichSubs});
    mrVista 3

    % for sub01
    DTs=[]; 
    DTsOdd=[49 51 53 55 57 59];
    DTsEven=[50 52 54 56 58 60];

    DTsAll=[DTs; DTsOdd; DTsEven];
    allXvalDTs=[DTsOdd; DTsEven];
    DTsAll=DTsAll(:);
    allXvalDTs=allXvalDTs(:);

    for thisSub=whichSubs
        % Uncomment to run over multiple participants with same DT numbering
    %    cd(paths{thisSub})
    %    mrVista 3;


       for n=1:2:length(allXvalDTs)
           fileCounter=0;
           allFiles={};
           for m=1:length(modelFileNames{1})
                files=dir(['Gray/' dataTYPES(allXvalDTs(n)).name, '/', char(modelFileNames{1}(m)),'.mat']);
                if length(files)==1;
                    fileCounter=fileCounter+1;
                    allFiles{fileCounter}=string(files.name);
                elseif length(files)==2
                    fileCounter=fileCounter+1;
                    if length(files(1).name)<length(files(2).name)
                        allFiles{fileCounter}=string(files(1).name);
                    else
                        allFiles{fileCounter}=string(files(2).name);
                    end
                elseif length(files)==3
                     fileCounter=fileCounter+1;
                     if length(files(1).name)<length(files(2).name)  && length(files(1).name)<length(files(3).name)
                         allFiles{fileCounter}=string(files(1).name);
                     elseif length(files(2).name)<length(files(1).name)  && length(files(2).name)<length(files(3).name)
                         allFiles{fileCounter}=string(files(2).name);
                     else
                        allFiles{fileCounter}=string(files(3).name);
                     end
                end
           end

           thisPath=['Gray/' dataTYPES(allXvalDTs(n)).name, '/'];
           otherPath=['Gray/' dataTYPES(allXvalDTs(n+1)).name, '/'];
           eval(['!mkdir ',  '"',otherPath, 'xval"']); %Model fit on other half of data
           eval(['!mkdir ',  '"',otherPath, 'xvalRefit"']); %Model refit to this half of data

           for whichFile=1:length(allFiles)
               eval(['!cp ', '"', thisPath, char(allFiles{whichFile}), '" "', otherPath, 'xval/xval-', char(allFiles{whichFile}), '"']);
           end
       end
       for n=2:2:length(allXvalDTs)
           fileCounter=0;
           allFiles={};
           for m=1:length(modelFileNames{1})
                files=dir(['Gray/' dataTYPES(allXvalDTs(n)).name, '/', char(modelFileNames{1}(m)),'.mat']);
                if length(files)==1
                    fileCounter=fileCounter+1;
                    allFiles{fileCounter}=string(files.name);
                elseif length(files)==2
                    fileCounter=fileCounter+1;
                    if length(files(1).name)<length(files(2).name)
                        allFiles{fileCounter}=string(files(1).name);
                    else
                        allFiles{fileCounter}=string(files(2).name);
                    end
                elseif length(files)==3
                     fileCounter=fileCounter+1;
                     if length(files(1).name)<length(files(2).name)  && length(files(1).name)<length(files(3).name)
                         allFiles{fileCounter}=string(files(1).name);
                     elseif length(files(2).name)<length(files(1).name)  && length(files(2).name)<length(files(3).name)
                         allFiles{fileCounter}=string(files(2).name);
                     else
                         allFiles{fileCounter}=string(files(3).name);
                     end
                end
           end

           thisPath=['Gray/' dataTYPES(allXvalDTs(n)).name, '/'];
           otherPath=['Gray/' dataTYPES(allXvalDTs(n-1)).name, '/'];
           eval(['!mkdir ',  '"',otherPath, 'xval"']);
           eval(['!mkdir ',  '"',otherPath, 'xvalRefit"']);

           for whichFile=1:length(allFiles)
               eval(['!cp ', '"', thisPath, char(allFiles{whichFile}), '" "', otherPath, 'xval/xval-', char(allFiles{whichFile}), '"']);
           end
       end
    end
    close all;
end








%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Step 5: cross-validation
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% !!!WARNING!!!
% running this script will overwrite some of the original files
% be 100% sure before running it
% also should always run step 1 first then 2 then 3 then 4 then 5 (not always..., so check)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%have not run for s25 2025.9.22
% paths{1}= '/media/Storage1/NumerosityAttention/s19/mrVistaSession_s19_Combined_NumerosityAttention-Pilot2-WhiteMatter'; %TODO fill in and adapt new_subjNames
% paths{2}= '/media/Storage1/NumerosityAttention/s22/mrVistaSession_s22_NumerosityAttentionSession1';
% paths{3}= '/media/Storage1/NumerosityAttention/s24/mrVistaSession_S24_NumerosityAttention_Session1';
% paths{4}= '/media/Storage1/NumerosityAttention/s25/mrVistaSession_s25_NumerosityAttentionSession1(this)';
% paths{5}= '/media/Storage1/NumerosityAttention/s28/mrVistaSession_s28_NumerosityAttentionSession1-WhiteMatter';
% paths{6}= '/media/Storage1/NumerosityAttention/s01/mrVistaSession_s01_NumerosityAttentionSession1(This) (copy)';
% paths{7}= '/media/Storage1/NumerosityAttention/s29/withWhiteMatter(All this)/mrVistaSession_s29_NumerosityAttentionSession1(this)';
% paths{8}= '/media/Storage1/NumerosityAttention/s30/mrVistaSession_s30_NumerosityAttention_Session1(This)';


clear;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      clear;
clc;
close all;
addpath('/media/harveylab/500GB/Yichen/Code');

paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';
paths{2}='/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession';
paths{3}='/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession';
paths{4}='/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession';
paths{5}='/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1';
paths{6}='/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession';
paths{7}='/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession';
paths{8}='/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1';

whichSubs = [1];

DTs=[]; 
DTsOdd=[49 51 53 55 57 59];
DTsEven=[50 52 54 56 58 60];
DTsOdd=[57 59 ];
DTsEven=[58 60 ];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);


DTsAll2=[DTs; DTsOdd; DTsEven];
allXvalDTs2=[DTsOdd; DTsEven];
DTsAll2=DTsAll2(:);
allXvalDTs2=allXvalDTs2(:);
combinedDTsAll{1}=allXvalDTs;
% 

allowRescale=2; %0 allows no rescaling. 1 allows every component to rescale independently (so has more freedom with more complex models). 2 fixes the ratios of the components and only allows one rescaling degree
baseModelNames=["*n-DT0.5-ILD-Linear*gFit*",...
    "*n-DT0.5-ILD-Log*-gFit*", "*n-DT0.5-ILD-originalLog*-gFit*",...
    "*1DCompressiveMonotonic-DT0.5-dBRight-Log*", ...
    "*1DCompressiveMonotonic-DT0.5-dBLeft-Log*", ...
    "*1DCompressiveWeighted-DT0.5-dB-Log*"];
modelNames=baseModelNames;

% roiName='gray-Layer1';
roiName='LeftBAMap';

for whichSub=whichSubs
    cd(paths{whichSub})
    fprintf('\n=== Processing Subject %d ===\n', whichSub);

    OddDTs  =  combinedDTsAll{whichSub}(1:2:end);
    EvenDTs =  combinedDTsAll{whichSub}(2:2:end);
    Mix2DTs=OddDTs;
    Mix5DTs=EvenDTs;

    try
        close(1); mrvCleanWorkspace;
    end

    mrVista 3;
    [VOLUME{1}] = loadROI(VOLUME{1}, roiName, [], [], 0, 1);
    for whichDT=1:length(Mix2DTs)
        for whichSplit=1:2;
            if whichSplit==1
                VOLUME{1}.curDataType=Mix2DTs(whichDT);%This determines where to load the data from. Use the OTHER split, and compare the the model from THIS split
                paramsDTname=dataTYPES(Mix5DTs(whichDT)).name;
                modelDTname=dataTYPES(Mix2DTs(whichDT)).name;

            else
                VOLUME{1}.curDataType=Mix5DTs(whichDT);
                paramsDTname=dataTYPES(Mix2DTs(whichDT)).name;
                modelDTname=dataTYPES(Mix5DTs(whichDT)).name;
            end            

            for whichModel=1:length(modelNames)
                %Load the PARAMS we want, which depend where the data will come from 
                file=dir(fullfile('Gray/', paramsDTname, '/', 'xval/',char(modelNames(whichModel))));%LZ added 'Xval',because all models we want to use  are in this file
                % thisModelName=modelFiles(whichModel);%LZ added 'Xval',because all models we want to use  are in this file
                if length(file)==1;
                    thisModelName=file;
                elseif length(file)==2
                    if length(file(1).name)<length(file(2).name)
                        thisModelName=file(1);
                    else
                        thisModelName=file(2);
                    end
                elseif length(file)==3
                     if length(file(1).name)<length(file(2).name)  && length(file(1).name)<length(file(3).name)
                        thisModelName=file(1);
                     elseif length(file(2).name)<length(file(1).name)  && length(file(2).name)<length(file(3).name)
                        thisModelName=file(2);
                     else
                        thisModelName=file(3);
                     end
                end
                load(fullfile('Gray/', paramsDTname, '/', 'xval/',thisModelName.name));
                paramsXval=params;

                %Load the MODEL we want
                % thisModelName=dir(fullfile('Gray/', modelDTname, '/', 'Xval',char(modelNames(whichModel))));%LZ added 'Xval',because all models we want to use  are in this file
                file2=dir(fullfile('Gray/', modelDTname, '/', 'xval/',char(modelNames(whichModel))));%LZ added 'Xval',because all models we want to use  are in this file
                if length(file2)==1;
                    thisModelName2=file2;
                elseif length(file2)==2
                    if length(file2(1).name)<length(file2(2).name)
                        thisModelName2=file2(1);
                    else
                        thisModelName2=file2(2);
                    end
                elseif length(file2)==3
                     if length(file2(1).name)<length(file2(2).name)  && length(file2(1).name)<length(file2(3).name)
                        thisModelName2=file2(1);
                     elseif length(file2(2).name)<length(file2(1).name)  && length(file2(2).name)<length(file2(3).name)
                        thisModelName2=file2(2);
                     else
                        thisModelName2=file2(3);
                     end
                end
                load(fullfile('Gray/', modelDTname, '/', 'xval/',thisModelName2.name));

                params=paramsXval; %IMPORTANT set the parameters to the other half of the data, on which the model was NOT fit. Mostly this allows for models fit from different stimulus sequences to be cross-validated

                %Load data
                params.wData='roi';

                %FOR TESTING, REMOVE LATER
                % params.analysis.calcPC=0;

                [data] = rmLoadData(VOLUME{1}, params, 1,params.analysis.coarseToFine);
                data(isnan(data)) = 0;
                data       = single(data);
                clear('ROIcoords');
                % coords of ROI in all data
                [tmp, ROIcoords]=intersectCols(VOLUME{1}.coords, VOLUME{1}.ROIs(end).coords); 

                %Now make predicted timeseries
                [trends, ntrends, dcid]  = rmMakeTrends(params);
                trends = single(trends);

                trendBetas = pinv(trends)*data;
                %if isfield(params.analysis,'allnuisance')
                %    trendBetas(ntrends+1:end) = 0;
                %    ntrends = ntrends + size(params.analysis.allnuisance,2);
                %end


                data       = data - trends*trendBetas;
                
                if length(model{1}.beta)<length(model{1}.x0) % size of gray vs. size of alldata
                    [VOLUME{1}] = loadROI(VOLUME{1}, params.roi.name, [], [], 0, 1);
                    % coords of roi in gray
                    [tmp, ROIcoords2, ib]=intersectCols(VOLUME{1}.ROIs(2).coords, VOLUME{1}.ROIs(1).coords); 
                    ROIbetas=squeeze(model{1}.beta(1,ROIcoords2, :));
                    VOLUME{1} = deleteROI(VOLUME{1},2);
                else
                    ROIbetas=squeeze(model{1}.beta(1,ROIcoords, :));
                end
                % ROIbetas=squeeze(model{1}.beta(1,ROIcoords, :));
                trendBetas=trendBetas';
                if isfield(params.stim, 'nGLMpredictors')
                    trendBetas(:,2+params.stim.nGLMpredictors:(size(trendBetas,2)+1+params.stim.nGLMpredictors))=trendBetas;
                    trendBetas(:,1:1+params.stim.nGLMpredictors)=0;
                elseif strcmp(params.analysis.pRFmodel{1},'1dglm')
                    trendBetas(:,(1+size(params.analysis.allstimimages,2)):(size(trendBetas,2)+size(params.analysis.allstimimages,2)))=trendBetas;
                    trendBetas(:,1:size(params.analysis.allstimimages,2))=0;  %HERE
                else
                    if size(ROIbetas,2)==ntrends+1
                        trendBetas(:,2:(size(trendBetas,2)+1))=trendBetas;
                        trendBetas(:,1)=0;
                    elseif size(ROIbetas,2)==ntrends+2
                        trendBetas(:,3:(size(trendBetas,2)+2))=trendBetas;
                        trendBetas(:,1:2)=0;
                    end
                end

                ROIbetas=ROIbetas-trendBetas;
                % if contains(modelNames, 'ILD-Log')
                %     params.analysis.X = sinh(params.analysis.X);
                %     params.analysis.Y = sinh(params.analysis.Y);
                % end
                % loop every voxel in selected roi
                for whichVoxel=1:size(data,2)
                    modelName = rmGet(model{1}, 'desc');

                    params.analysis.x0=model{1}.x0(ROIcoords(whichVoxel)); % coords of rois in all data (not sorted)
                    params.analysis.y0=model{1}.y0(ROIcoords(whichVoxel));
                    try
                        params.analysis.sigmaMajor=model{1}.sigma.major(ROIcoords(whichVoxel));
                    end
                    try
                        params.analysis.sigmaMinor=model{1}.sigma.minor(ROIcoords(whichVoxel));
                    end
                    try
                        params.analysis.theta=model{1}.sigma.theta(ROIcoords(whichVoxel));
                    end
                    try
                        params.analysis.exponent=model{1}.exponent(ROIcoords(whichVoxel));
                    end

                    [prediction, prediction2, RFs, rf2, glmPredictor]=rmGridFit_makePrediction(params);

                    if allowRescale==0
                        if size(glmPredictor, 1)>0
                            scaledPrediction=prediction.*ROIbetas(whichVoxel, 1)+glmPredictor*ROIbetas(whichVoxel, 2:1+size(glmPredictor, 2))'+trends(:,dcid)*ROIbetas(whichVoxel, 2+size(glmPredictor, 2));%+trends(2)*ROIbetas(whichVoxel, 3);
                        elseif strcmp(params.analysis.pRFmodel{1},'1dglm')
                            scaledPrediction=prediction*ROIbetas(whichVoxel, 1:size(params.analysis.allstimimages,2))'+trends(:,dcid)*ROIbetas(whichVoxel, 2+size(params.analysis.allstimimages, 2));
                        else
                            scaledPrediction=prediction.*ROIbetas(whichVoxel, 1)+trends(:,dcid)*ROIbetas(whichVoxel, 2+size(glmPredictor, 2));%+trends(2)*ROIbetas(whichVoxel, 3);
                        end
                    elseif allowRescale==1
                        if size(glmPredictor, 1)>0
                            X    = [prediction(:,n) glmPredictor trends(:,dcid)];
                            [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                            if b(1)<0
                                X=[glmPredictor trends(:,dcid)];
                                [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                                scaledPrediction=glmPredictor*b(2:1+size(glmPredictor, 2))+trends(:,dcid)*b(end+(1-length(dcid)):end);
                            else
                                scaledPrediction=prediction.*b(1)+glmPredictor*b(2:1+size(glmPredictor, 2))+trends(:,dcid)*b(end+(1-length(dcid)):end);
                            end
                        elseif strcmp(params.analysis.pRFmodel{1},'1dglm')
                            X    = [prediction trends(:,dcid)];
                            [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                            scaledPrediction=prediction*b(1:size(params.analysis.allstimimages,2))+trends(:,dcid)*b(end+(1-length(dcid)):end);
                        else
                            X    = [prediction(:,n) trends(:,dcid)];
                            [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                            if b(1)<0
                                X=[trends(:,dcid)];
                                [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                                scaledPrediction=trends(:,dcid)*b(end+(1-length(dcid)):end);
                            else
                                scaledPrediction=prediction.*b(1)+trends(:,dcid)*b(end+(1-length(dcid)):end);
                            end
                        end
                        %IF USING THIS RESCALE=1, ADD CODE TO SAVE BETAS
                    elseif allowRescale==2
                        if size(glmPredictor, 1)>0
                            scaledPrediction=prediction.*ROIbetas(whichVoxel, 1)+glmPredictor*ROIbetas(whichVoxel, 2:1+size(glmPredictor, 2))'+trends(:,dcid)*ROIbetas(whichVoxel, 2+size(glmPredictor, 2));%+trends(2)*ROIbetas(whichVoxel, 3);
                        elseif strcmp(params.analysis.pRFmodel{1},'1dglm')
                            scaledPrediction=prediction*ROIbetas(whichVoxel, 1:size(params.analysis.allstimimages,2))'+trends(:,dcid)*ROIbetas(whichVoxel, 2+size(params.analysis.allstimimages, 2));
                        else
                            if isempty(prediction2)
                                % ROIbetas - coords of beta in gray (sorted)
                                scaledPrediction=prediction.*ROIbetas(whichVoxel, 1);%+trends(:,dcid)*ROIbetas(whichVoxel, 2+size(glmPredictor, 2));%+trends(2)*ROIbetas(whichVoxel, 3);
                            else
                                scaledPrediction=prediction.*ROIbetas(whichVoxel, 1)+prediction2.*ROIbetas(whichVoxel, 2);%+trends(:,dcid)*ROIbetas(whichVoxel, 3+size(glmPredictor, 2));%+trends(2)*ROIbetas(whichVoxel, 3);
                            end
                        end
                        X    = [scaledPrediction trends(:,dcid)];
                        [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                        % if b(1)<0
                        if b(1)<=0  
                            X=[trends(:,dcid)];
                            [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                            scaledPrediction=trends(:,dcid)*b(end+(1-length(dcid)):end);
                            b=[0 b];
                        else
                            scaledPrediction=scaledPrediction.*b(1)+trends(:,dcid)*b(end+(1-length(dcid)):end);
                            % scaledPrediction=scaledPrediction.*b(1)+trends(:,dcid)*b(end);
                        end
                    
                        if ~isempty(prediction2)
                            % ROIbetas - coords of beta in gray (sorted)
                            b1ratio=ROIbetas(whichVoxel, 1)/(ROIbetas(whichVoxel, 1)+ROIbetas(whichVoxel, 2));
                            b2ratio=ROIbetas(whichVoxel, 2)/(ROIbetas(whichVoxel, 1)+ROIbetas(whichVoxel, 2));
                            b=[b(1)*b1ratio*ROIbetas(whichVoxel, 1), b(1)*b2ratio*ROIbetas(whichVoxel, 2), b(2:end)*ROIbetas(whichVoxel, 3+size(glmPredictor, 2))];
                            model{1}.beta(1,ROIcoords(whichVoxel),:)=0;
                            model{1}.beta(1,ROIcoords(whichVoxel), [1:size(glmPredictor,2)+2, dcid+size(glmPredictor,2)+2])=b; % check this
                            model{1}.beta(1,ROIcoords(whichVoxel),:) = model{1}.beta(1,ROIcoords(whichVoxel),:)+reshape(trendBetas(whichVoxel,:), [1 size(trendBetas(whichVoxel,:),1) size(trendBetas(whichVoxel,:),2)]);
                        else
                            b=[b(1)*ROIbetas(whichVoxel, 1), b(2:end)*ROIbetas(whichVoxel, 2+size(glmPredictor, 2))];
                            model{1}.beta(1,ROIcoords(whichVoxel),:)=0;
                            model{1}.beta(1,ROIcoords(whichVoxel), [1:size(glmPredictor,2)+1, dcid+size(glmPredictor,2)+1])=b;
                            model{1}.beta(1,ROIcoords(whichVoxel),:) = model{1}.beta(1,ROIcoords(whichVoxel),:)+reshape(trendBetas(whichVoxel,:), [1 size(trendBetas(whichVoxel,:),1) size(trendBetas(whichVoxel,:),2)]);
                        end
                    end

                    % model{1}.beta(1,ROIcoords(whichVoxel),:)=0;
                    % model{1}.beta(1,ROIcoords(whichVoxel), [1:size(glmPredictor,2)+1, dcid+size(glmPredictor,2)+1])=b;
                    % model{1}.beta(1,ROIcoords(whichVoxel),:) = model{1}.beta(1,ROIcoords(whichVoxel),:)+reshape(trendBetas(whichVoxel,:), [1 size(trendBetas(whichVoxel,:),1) size(trendBetas(whichVoxel,:),2)]);


                    %model{1}.rss(ROIcoords(whichVoxel))./sum((scaledPrediction-data(:,whichVoxel)).^2)/(length(prediction)/(length(prediction)-2))             
                    model{1}.rss(ROIcoords(whichVoxel))=sum((scaledPrediction-data(:,whichVoxel)).^2);%/(length(prediction)/(length(prediction)-2));
                    model{1}.rawrss(ROIcoords(whichVoxel))=sum((mean(data(:,whichVoxel))-data(:,whichVoxel)).^2);
                    % model{1}.rawrss(ROIcoords(whichVoxel))=sum((data(:,whichVoxel)).^2);
                end
                %params=params_original;
                params.analysis.allowRescale=allowRescale;
                MakefilePath=thisModelName2.folder;
                MakefilePath = replace(MakefilePath, "/xval", "");
                % we read data in Xval file and save data in xValRefit
                % both within Each DT file, because I already checked model
                % data in Xval file
                try
                    save(fullfile(MakefilePath, '/xValRefitNew/', thisModelName2.name), 'model', 'params');
                catch
                    mkdir(fullfile(MakefilePath, '/xValRefitNew/'));
                    save(fullfile(MakefilePath, '/xValRefitNew/', thisModelName2.name), 'model', 'params');
                end
            end
        end
    end
end




%% old cv
clear;
clc;
close all;
addpath('/media/harveylab/500GB/Yichen/Code');

paths{1}='/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession';

whichSubs = [1];

DTs=[]; 
DTsOdd=[22 24 28 30 32 38 40 42];
DTsEven=[23 25 29 31 33 39 41 43];

DTsAll=[DTs; DTsOdd; DTsEven];
allXvalDTs=[DTsOdd; DTsEven];
DTsAll=DTsAll(:);
allXvalDTs=allXvalDTs(:);


DTsAll2=[DTs; DTsOdd; DTsEven];
allXvalDTs2=[DTsOdd; DTsEven];
DTsAll2=DTsAll2(:);
allXvalDTs2=allXvalDTs2(:);
combinedDTsAll{1}=allXvalDTs;


% combinedDTsAll{1}=[15 13 14 4 29 25 27 5 30 26 28 6 24 22 23 11 63 59 61 9 64 60 62 10];%checked s19
% combinedDTsAll{2}=[15 13 14 4 29 25 27 5 30 26 28 6 24 22 23 11 63 59 61 9 64 60 62 10];%checked s22
% combinedDTsAll{3}=[15 13 14 4 29 25 27 5 30 26 28 6 24 22 23 11 63 59 61 9 64 60 62 10];%checked s24
% combinedDTsAll{4}=[15 13 14 4 29 25 27 5 30 26 28 6 24 22 23 11 63 59 61 9 64 60 62 10];%checked s25
% combinedDTsAll{5}=[15 13 14 4 29 25 27 5 30 26 28 6 24 22 23 11 63 59 61 9 64 60 62 10];%checked s28
% combinedDTsAll{6}=[15 13 14 4 29 25 27 5 30 26 28 6 24 22 23 11 63 59 61 9 64 60 62 10];%checked s01  
% 
% %only for sub 29
% %AttCshortCycle1 ,Att2shortCycle1,Att6shortCycle1, AttAshortCycle1 69 65 67 9
% %AttCshortCycle4,Att2shortCycle4,Att6shortCycle4, AttAshortCycle4 70 66 68 10
% combinedDTsAll{7}=[15 13 14 4    29 25 27 5    30 26 28 6   24 22 23 11    69 65 67 9    70 66 68 10];%checked 2025.2.14 this one is different with others s29
% combinedDTsAll{8}=[15 13 14 4  29 25 27 5      30 26 28 6   24 22 23 11    63 59 61 9    64 60 62 10];%checked s30



allowRescale=2; %0 allows no rescaling. 1 allows every component to rescale independently (so has more freedom with more complex models). 2 fixes the ratios of the components and only allows one rescaling degree

baseModelNames=["*Mirrored*-ILD-Log*", "*Mirrored*-originalLog*",...
    "*1DCompressiveWeighted-DT0.5-dB-Log*"];
modelNames=baseModelNames;
% roiName='gray-Layer1';
roiName='LeftBAMap';

% whichSubs=4:8;
for whichSub=whichSubs
    cd(paths{whichSub})
    fprintf('\n=== Processing Subject %d ===\n', whichSub);

    % OddDTs  =  dtsPerSub(whichSub)+1;
    % EvenDTs =  dtsPerSub(whichSub)+2;
    OddDTs  =  combinedDTsAll{whichSub}(1:2:end);
    EvenDTs =  combinedDTsAll{whichSub}(2:2:end);
    Mix2DTs=OddDTs;
    Mix5DTs=EvenDTs;
    % Mix2DTs=combinedDTsAll{whichSub}(5:8);
    % Mix5DTs=combinedDTsAll{whichSub}(9:12);

    try
        close(1); mrvCleanWorkspace;
    end

    mrVista 3;
    [VOLUME{1}] = loadROI(VOLUME{1}, roiName, [], [], 0, 1);
    for whichDT=1:length(Mix2DTs)
        for whichSplit=1:2;
            if whichSplit==1
                VOLUME{1}.curDataType=Mix2DTs(whichDT);%This determines where to load the data from. Use the OTHER split, and compare the the model from THIS split
                paramsDTname=dataTYPES(Mix5DTs(whichDT)).name;
                modelDTname=dataTYPES(Mix2DTs(whichDT)).name;

            else
                VOLUME{1}.curDataType=Mix5DTs(whichDT);
                paramsDTname=dataTYPES(Mix2DTs(whichDT)).name;
                modelDTname=dataTYPES(Mix5DTs(whichDT)).name;
            end            
            % folderName=[pwd '/Gray/' dataTYPES(allXvalDTs(whichDT)).name, '/xval'];
            % modelFiles=dir([folderName '/*.mat']);
            % folderName2=[pwd '/Gray/' dataTYPES(allXvalDTs(whichDT)).name, '/xval'];
            % modelFiles=dir([folderName '/*.mat']);

            % for whichModel=1:length(modelNames)
            % for whichModel=[7 11 13]
            for whichModel=1:length(modelNames)
                %Load the PARAMS we want, which depend where the data will come from 
                file=dir(fullfile('Gray/', paramsDTname, '/', 'xval/',char(modelNames(whichModel))));%LZ added 'Xval',because all models we want to use  are in this file
                % thisModelName=modelFiles(whichModel);%LZ added 'Xval',because all models we want to use  are in this file
                if length(file)==1;
                    thisModelName=file;
                elseif length(file)==2
                    if length(file(1).name)<length(file(2).name)
                        thisModelName=file(1);
                    else
                        thisModelName=file(2);
                    end
                elseif length(file)==3
                     if length(file(1).name)<length(file(2).name)  && length(file(1).name)<length(file(3).name)
                        thisModelName=file(1);
                     elseif length(file(2).name)<length(file(1).name)  && length(file(2).name)<length(file(3).name)
                        thisModelName=file(2);
                     else
                        thisModelName=file(3);
                     end
                end
                load(fullfile('Gray/', paramsDTname, '/', 'xval',thisModelName.name));
                paramsXval=params;

                %Load the MODEL we want
                % thisModelName=dir(fullfile('Gray/', modelDTname, '/', 'Xval',char(modelNames(whichModel))));%LZ added 'Xval',because all models we want to use  are in this file
                file2=dir(fullfile('Gray/', modelDTname, '/', 'xval/',char(modelNames(whichModel))));%LZ added 'Xval',because all models we want to use  are in this file
                if length(file2)==1;
                    thisModelName2=file2;
                elseif length(file2)==2
                    if length(file2(1).name)<length(file2(2).name)
                        thisModelName2=file2(1);
                    else
                        thisModelName2=file2(2);
                    end
                elseif length(file2)==3
                     if length(file2(1).name)<length(file2(2).name)  && length(file2(1).name)<length(file2(3).name)
                        thisModelName2=file2(1);
                     elseif length(file2(2).name)<length(file2(1).name)  && length(file2(2).name)<length(file2(3).name)
                        thisModelName2=file2(2);
                     else
                        thisModelName2=file2(3);
                     end
                end
                load(fullfile('Gray/', modelDTname, '/', 'xval',thisModelName2.name));

                params=paramsXval; %IMPORTANT set the parameters to the other half of the data, on which the model was NOT fit. Mostly this allows for models fit from different stimulus sequences to be cross-validated

                %Load data
                params.wData='roi';
                [data] = rmLoadData(VOLUME{1}, params, 1,params.analysis.coarseToFine);
                data(isnan(data)) = 0;
                data       = single(data);
                clear('ROIcoords');
                % coords of ROI in all data
                [tmp, ROIcoords]=intersectCols(VOLUME{1}.coords, VOLUME{1}.ROIs(end).coords); 

                %Now make predicted timeseries
                [trends, ntrends, dcid]  = rmMakeTrends(params);
                trends = single(trends);

                trendBetas = pinv(trends)*data;
                %if isfield(params.analysis,'allnuisance')
                %    trendBetas(ntrends+1:end) = 0;
                %    ntrends = ntrends + size(params.analysis.allnuisance,2);
                %end


                data       = data - trends*trendBetas;
                
                if length(model{1}.beta)<length(model{1}.x0) % size of gray vs. size of alldata
                    [VOLUME{1}] = loadROI(VOLUME{1}, params.roi.name, [], [], 0, 1);
                    % coords of roi in gray
                    [tmp, ROIcoords2, ib]=intersectCols(VOLUME{1}.ROIs(2).coords, VOLUME{1}.ROIs(1).coords); 
                    ROIbetas=squeeze(model{1}.beta(1,ROIcoords2, :));
                    VOLUME{1} = deleteROI(VOLUME{1},2);
                else
                    ROIbetas=squeeze(model{1}.beta(1,ROIcoords, :));
                end
                % ROIbetas=squeeze(model{1}.beta(1,ROIcoords, :));
                trendBetas=trendBetas';
                if isfield(params.stim, 'nGLMpredictors')
                    trendBetas(:,2+params.stim.nGLMpredictors:(size(trendBetas,2)+1+params.stim.nGLMpredictors))=trendBetas;
                    trendBetas(:,1:1+params.stim.nGLMpredictors)=0;
                elseif strcmp(params.analysis.pRFmodel{1},'1dglm')
                    trendBetas(:,(1+size(params.analysis.allstimimages,2)):(size(trendBetas,2)+size(params.analysis.allstimimages,2)))=trendBetas;
                    trendBetas(:,1:size(params.analysis.allstimimages,2))=0;  %HERE
                else
                    if size(ROIbetas,2)==ntrends+1
                        trendBetas(:,2:(size(trendBetas,2)+1))=trendBetas;
                        trendBetas(:,1)=0;
                    elseif size(ROIbetas,2)==ntrends+2
                        trendBetas(:,3:(size(trendBetas,2)+2))=trendBetas;
                        trendBetas(:,1:2)=0;
                    end
                end

                ROIbetas=ROIbetas-trendBetas;
                % loop every voxel in selected roi
                for whichVoxel=1:size(data,2)
                    modelName = rmGet(model{1}, 'desc');

                    params.analysis.x0=model{1}.x0(ROIcoords(whichVoxel)); % coords of rois in all data (not sorted)
                    params.analysis.y0=model{1}.y0(ROIcoords(whichVoxel));
                    try
                        params.analysis.sigmaMajor=model{1}.sigma.major(ROIcoords(whichVoxel));
                    end
                    try
                        params.analysis.sigmaMinor=model{1}.sigma.minor(ROIcoords(whichVoxel));
                    end
                    try
                        params.analysis.theta=model{1}.sigma.theta(ROIcoords(whichVoxel));
                    end
                    try
                        params.analysis.exponent=model{1}.exponent(ROIcoords(whichVoxel));
                    end

                    [prediction, prediction2, RFs, rf2, glmPredictor]=rmGridFit_makePrediction(params);

                    if allowRescale==0
                        if size(glmPredictor, 1)>0
                            scaledPrediction=prediction.*ROIbetas(whichVoxel, 1)+glmPredictor*ROIbetas(whichVoxel, 2:1+size(glmPredictor, 2))'+trends(:,1)*ROIbetas(whichVoxel, 2+size(glmPredictor, 2));%+trends(2)*ROIbetas(whichVoxel, 3);
                        elseif strcmp(params.analysis.pRFmodel{1},'1dglm')
                            scaledPrediction=prediction*ROIbetas(whichVoxel, 1:size(params.analysis.allstimimages,2))'+trends(:,1)*ROIbetas(whichVoxel, 2+size(params.analysis.allstimimages, 2));
                        else
                            scaledPrediction=prediction.*ROIbetas(whichVoxel, 1)+trends(:,1)*ROIbetas(whichVoxel, 2+size(glmPredictor, 2));%+trends(2)*ROIbetas(whichVoxel, 3);
                        end
                    elseif allowRescale==1
                        if size(glmPredictor, 1)>0
                            X    = [prediction(:,n) glmPredictor trends(:,1)];
                            [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                            if b(1)<0
                                X=[glmPredictor trends(:,1)];
                                [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                                scaledPrediction=glmPredictor*b(2:1+size(glmPredictor, 2))+trends(:,1)*b(end);
                            else
                                scaledPrediction=prediction.*b(1)+glmPredictor*b(2:1+size(glmPredictor, 2))+trends(:,1)*b(end);
                            end
                        elseif strcmp(params.analysis.pRFmodel{1},'1dglm')
                            X    = [prediction trends(:,1)];
                            [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                            scaledPrediction=prediction*b(1:size(params.analysis.allstimimages,2))+trends(:,1)*b(end);
                        else
                            X    = [prediction(:,n) trends(:,1)];
                            [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                            if b(1)<0
                                X=[trends(:,1)];
                                [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                                scaledPrediction=trends(:,1)*b(end);
                            else
                                scaledPrediction=prediction.*b(1)+trends(:,1)*b(end);
                            end
                        end
                    elseif allowRescale==2
                        if size(glmPredictor, 1)>0
                            scaledPrediction=prediction.*ROIbetas(whichVoxel, 1)+glmPredictor*ROIbetas(whichVoxel, 2:1+size(glmPredictor, 2))'+trends(:,1)*ROIbetas(whichVoxel, 2+size(glmPredictor, 2));%+trends(2)*ROIbetas(whichVoxel, 3);
                        elseif strcmp(params.analysis.pRFmodel{1},'1dglm')
                            scaledPrediction=prediction*ROIbetas(whichVoxel, 1:size(params.analysis.allstimimages,2))'+trends(:,1)*ROIbetas(whichVoxel, 2+size(params.analysis.allstimimages, 2));
                        else
                            if isempty(prediction2)
                                % ROIbetas - coords of beta in gray (sorted)
                                scaledPrediction=prediction.*ROIbetas(whichVoxel, 1)+trends(:,1)*ROIbetas(whichVoxel, 2+size(glmPredictor, 2));%+trends(2)*ROIbetas(whichVoxel, 3);
                            else
                                scaledPrediction=prediction.*ROIbetas(whichVoxel, 1)+prediction2.*ROIbetas(whichVoxel, 2)+trends(:,1)*ROIbetas(whichVoxel, 3+size(glmPredictor, 2));%+trends(2)*ROIbetas(whichVoxel, 3);
                            end
                        end
                        X    = [scaledPrediction trends(:,1)];
                        [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                        % if b(1)<0
                        if b(1)<=0  
                            X=[trends(:,1)];
                            [b,ci,rss]    = lscov(X,data(:,whichVoxel));
                            scaledPrediction=trends(:,1)*b(end);
                            b=[0 b];
                        else
                            scaledPrediction=scaledPrediction.*b(1)+trends(:,1)*b(end);
                            % scaledPrediction=scaledPrediction.*b(1)+trends(:,1)*b(end);
                        end
                    end
                    if ~isempty(prediction2)
                        % ROIbetas - coords of beta in gray (sorted)
                        b1ratio=ROIbetas(whichVoxel, 1)/(ROIbetas(whichVoxel, 1)+ROIbetas(whichVoxel, 2));
                        b2ratio=ROIbetas(whichVoxel, 2)/(ROIbetas(whichVoxel, 1)+ROIbetas(whichVoxel, 2));
                        b=[b(1)*b1ratio*ROIbetas(whichVoxel, 1), b(1)*b2ratio*ROIbetas(whichVoxel, 2), b(2:end)*ROIbetas(whichVoxel, 3+size(glmPredictor, 2))];
                        model{1}.beta(1,ROIcoords(whichVoxel),:)=0;% check this, beta is for gray, while coords is for all data
                        model{1}.beta(1,ROIcoords(whichVoxel), [1:size(glmPredictor,2)+2, dcid+size(glmPredictor,2)+2])=b; % check this
                        model{1}.beta(1,ROIcoords(whichVoxel),:) = model{1}.beta(1,ROIcoords(whichVoxel),:)+reshape(trendBetas(whichVoxel,:), [1 size(trendBetas(whichVoxel,:),1) size(trendBetas(whichVoxel,:),2)]);
                    else
                        b=[b(1)*ROIbetas(whichVoxel, 1), b(2:end)*ROIbetas(whichVoxel, 2+size(glmPredictor, 2))];
                        model{1}.beta(1,ROIcoords(whichVoxel),:)=0;
                        model{1}.beta(1,ROIcoords(whichVoxel), [1:size(glmPredictor,2)+1, dcid+size(glmPredictor,2)+1])=b;
                        model{1}.beta(1,ROIcoords(whichVoxel),:) = model{1}.beta(1,ROIcoords(whichVoxel),:)+reshape(trendBetas(whichVoxel,:), [1 size(trendBetas(whichVoxel,:),1) size(trendBetas(whichVoxel,:),2)]);
                    end

                    % model{1}.beta(1,ROIcoords(whichVoxel),:)=0;
                    % model{1}.beta(1,ROIcoords(whichVoxel), [1:size(glmPredictor,2)+1, dcid+size(glmPredictor,2)+1])=b;
                    % model{1}.beta(1,ROIcoords(whichVoxel),:) = model{1}.beta(1,ROIcoords(whichVoxel),:)+reshape(trendBetas(whichVoxel,:), [1 size(trendBetas(whichVoxel,:),1) size(trendBetas(whichVoxel,:),2)]);


                    %model{1}.rss(ROIcoords(whichVoxel))./sum((scaledPrediction-data(:,whichVoxel)).^2)/(length(prediction)/(length(prediction)-2))             
                    model{1}.rss(ROIcoords(whichVoxel))=sum((scaledPrediction-data(:,whichVoxel)).^2);%/(length(prediction)/(length(prediction)-2));
                    model{1}.rawrss(ROIcoords(whichVoxel))=sum((data(:,whichVoxel)).^2);

                end
                %params=params_original;
                params.analysis.allowRescale=allowRescale;
                MakefilePath=thisModelName2.folder;
                MakefilePath = replace(MakefilePath, "/xval", "");
                % we read data in Xval file and save data in xValRefit
                % both within Each DT file, because I already checked model
                % data in Xval file
                try
                    save(fullfile(MakefilePath, '/xValRefitNew/', thisModelName2.name), 'model', 'params');
                catch
                    mkdir(fullfile(MakefilePath, '/xValRefitNew/'));
                    save(fullfile(MakefilePath, '/xValRefitNew/', thisModelName2.name), 'model', 'params');
                end
            end
        end
    end
end






