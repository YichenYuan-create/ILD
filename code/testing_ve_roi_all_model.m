
clear; clc;

%% ----------------------------
% Subject paths
%% ----------------------------
paths = {
    '/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession/Gray/MovingBinaural'
    '/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession/Gray/MovingBinaural'
    '/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession/Gray/MovingBinaural'
    '/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession/Gray/MovingBinaural'
    '/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1/Gray/MovingBinaural'
    '/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession/Gray/MovingBinaural'
    '/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession/Gray/MovingBinaural'
    '/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1/Gray/MovingBinaural'
};

%% ----------------------------
% Model filename prefixes
% Only keep the stable part before timestamp
%% ----------------------------
modelPatterns = {
    'retModel-1DCompressiveMonotonic-DT0.5-dBLeft_*-gFit.mat'
    'retModel-1DCompressiveMonotonic-DT0.5-dBLeft-Log_*-gFit.mat'
    'retModel-1DCompressiveMonotonic-DT0.5-dBRight_*-gFit.mat'
    'retModel-1DCompressiveMonotonic-DT0.5-dBRight-Log_*-gFit.mat'
    'retModel-1DCompressiveWeighted-DT0.5-dB_*-gFit.mat'
    'retModel-1DCompressiveWeighted-DT0.5-dB-Log_*-gFit.mat'
    'retModel-1DGaussian-DT0.5-ILD-Linear_*-gFit.mat'
    'retModel-1DGaussian-DT0.5-ILD-originalLog_*-gFit.mat'
};

outputFile = 'testmodel.mat';

%% ----------------------------
% Loop over subjects
%% ----------------------------
for iSub = 1:numel(paths)

    subjPath = paths{iSub};
    fprintf('\n=============================\n');
    fprintf('Processing subject %d / %d\n', iSub, numel(paths));
    fprintf('Path: %s\n', subjPath);

    if ~isfolder(subjPath)
        warning('Path does not exist: %s. Skipping.', subjPath);
        continue;
    end

    cd(subjPath);

    rss = [];
    rawrss = [];
    modelLoaded = false;
    nFound = 0;

    for iModel = 1:numel(modelPatterns)

        thisPattern = modelPatterns{iModel};
        files = dir(thisPattern);

        if isempty(files)
            warning('No file found for pattern:\n  %s\nin %s', thisPattern, subjPath);
            continue;
        end

        % If multiple files match, choose the newest one
        if numel(files) > 1
            [~, idxNewest] = max([files.datenum]);
            chosenFile = files(idxNewest).name;
            fprintf('Multiple matches for model %d, using newest: %s\n', iModel, chosenFile);
        else
            chosenFile = files(1).name;
            fprintf('Found model %d: %s\n', iModel, chosenFile);
        end

        S = load(chosenFile, 'model', 'params');

        % save template model/params from first successfully loaded file
        if ~modelLoaded
            outModel = S.model;
            outParams = S.params;
            modelLoaded = true;
        end

        rss(iModel, :) = S.model{1}.rss;
        rawrss(iModel, :) = S.model{1}.rawrss;
        nFound = nFound + 1;
    end

    if ~modelLoaded
        warning('No models loaded for %s. Skipping.', subjPath);
        continue;
    end

    if isempty(rss) || isempty(rawrss)
        warning('rss/rawrss empty for %s. Skipping.', subjPath);
        continue;
    end

    %% take minimum across models for each voxel
    outModel{1}.rss = min(rss, [], 1);
    outModel{1}.rawrss = min(rawrss, [], 1); % rawrss are the same
    model = outModel;
    params = outParams;
    save(outputFile, 'model', 'params');
    fprintf('Saved combined model to %s\n', fullfile(subjPath, outputFile));
    fprintf('Loaded %d models for this subject.\n', nFound);
end

