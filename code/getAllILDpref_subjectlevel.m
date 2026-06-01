function data_x = getAllILDpref_subjectlevel(dataStruct, subjID, mapNames, hemispheres, modelNames, whichModel, DTnames, whichDT, veThresh,scale,condition)
% ILDPreferenceHistograms2
% Generate ILD preference histograms for a given subject, model, and DT.
%
% INPUTS
%   dataStruct   : structure containing data (e.g., allData or dataAllSub)
%   subjID       : string, subject ID (e.g., "dataS01" or "dataAllSub")
%   mapNames     : cell/str array of ROI names
%   hemispheres  : cell array of hemisphere names, e.g. {'Left','Right'}
%   modelNames   : list of model names
%   whichModel   : index of modelNames to use
%   DTnames      : list of dataType names (string/cell array)
%   whichDT      : index into DTnames
%   veThresh     : variance explained threshold
%
% Example:
%   ILDPreferenceHistograms2(allData, "dataAllSub", baseMapNames, ...
%       {'Left','Right'}, baseModelNames, 1, baseDTnames(7:9), 1, 0);

if isstring(mapNames), mapNames = cellstr(mapNames); end
if isstring(modelNames), modelNames = cellstr(modelNames); end
if isstring(DTnames), DTnames = cellstr(DTnames); end
for ptc = 1:length(subjID)
    subj_num = subjID(ptc);
    dataname = ['dataS' sprintf('%02d', subj_num)];
    for whichMap = 1:length(mapNames)
        mapName = mapNames{whichMap};
    
        mapStruct = dataStruct.(condition).(dataname).(mapName);
        % if ~isfield(dataStruct.(subjID), mapName), continue; end
        % mapStruct = dataStruct.(subjID).(mapName);
        % 
        % Check if ROI exists

        for whichHemi = 1:numel(hemispheres)
            hemiName = hemispheres{whichHemi};
            if ~isfield(mapStruct, hemiName), continue; end
            hemiStruct = mapStruct.(hemiName);

            modelName = modelNames{whichModel};
            if ~isfield(hemiStruct, modelName), continue; end
            modelStruct = hemiStruct.(modelName);
            DTname = DTnames{whichDT};
            if ~isfield(modelStruct, DTname), continue; end
            data = modelStruct.(DTname);

            if (contains(modelName, 'original') || contains(modelName, 'ggfit')) && ~contains(modelName, 'Mirrored')
                % Simple histogram for original model
                if strcomp(scale,'log')==1
                    data_x{ptc,whichMap, whichHemi} = data.x0s(data.x0s>-4.1 & data.x0s<4.1 & data.ves>veThresh);
                elseif strcomp(scale,'lin')==1
                    data.x0s = sinh(data.x0s);
                    data_x{ptc,whichMap, whichHemi} = data.x0s(data.x0s>-25 & data.x0s<25 & data.ves>veThresh);
                end


            else
                % data_x = data.x0s(data.x0s>-25 & data.x0s<25 & data.ves>veThresh);
                % h=histogram(data_x, -25:25, 'FaceColor', 'none');
                % axis square;
                % xlim([-25 25]);
                % Weighted bar plot
                validIdx = data.x0s > -25 & data.x0s < 25 & data.ves > veThresh;
                data_x{ptc,whichMap, whichHemi} = data.x0s(validIdx);

            end
        end

    end
end
end