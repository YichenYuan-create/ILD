function [pref, sigma, stats] = roiPrefStats_allptc(dataStruct, subjID, mapNames, hemispheres, modelNames, whichModel, DTnames, whichDT, veThresh, scale, condition, varargin)
% roiPrefStats  Compute robust distribution descriptors for ILD preferences in [-20,20].
%
% INPUT
%   pref : vector of voxel-wise ILD preferences (should be within [-20, 20], NaNs allowed)
%
% OPTIONAL name-value
%   'Range'        : [min max], default [-20 20]
%   'BinWidth'     : histogram bin width in dB, default 1
%   'EdgeThr'      : edge threshold for "edge mass", default 18 (counts |pref|>=18)
%   'MinPeakProm'  : min peak prominence for KDE peak counting, default 0.02
%
% OUTPUT (struct)
%   medianPref, meanPref, trimmedMeanPref
%   IQRPref, MADPref, sdPref
%   skewPref, kurtPref
%   edgeMass
%   entropy
%   modeKDE, nPeaksKDE
%   n, nValid

p = inputParser;
p.addParameter('Range', [-20 20], @(x) isnumeric(x) && numel(x)==2);
p.addParameter('BinWidth', 1, @(x) isnumeric(x) && isscalar(x) && x>0);
p.addParameter('EdgeThr', 18, @(x) isnumeric(x) && isscalar(x));
p.addParameter('MinPeakProm', 0.02, @(x) isnumeric(x) && isscalar(x) && x>=0);
p.parse(varargin{:});
R = p.Results.Range;
binW = p.Results.BinWidth;
edgeThr = p.Results.EdgeThr;

for ptc = 1:length(subjID)
    subj_num = subjID(ptc);
    dataname = ['dataS' sprintf('%02d', subj_num)];
    for whichMap = 1:length(mapNames)
        mapName = mapNames{whichMap};
    
        % Check if ROI exists
        if isfield(dataStruct.(condition), dataname) && ...
                isfield(dataStruct.(condition).(dataname), mapName)

            mapStruct = dataStruct.(condition).(dataname).(mapName);
        else
            mapStruct = [];
        end

        % if ~isfield(dataStruct.(subjID), mapName), continue; end
        % mapStruct = dataStruct.(subjID).(mapName);
        % 
        for whichHemi = 1:numel(hemispheres)
            hemiName = hemispheres{whichHemi};
            if ~isfield(mapStruct, hemiName), continue; end
            hemiStruct = mapStruct.(hemiName);
    
            modelName = modelNames{whichModel};
            if ~isfield(hemiStruct, modelName), continue; end
            modelStruct = hemiStruct.(modelName);
 
            for dt = 1:length(whichDT)
                DTname = DTnames{whichDT(dt)};
                if ~isfield(modelStruct, DTname), continue; end
                data = modelStruct.(DTname);
        
                if (contains(modelName, 'original') || contains(modelName, 'ggfit')) && ~contains(modelName, 'Mirrored') && strcmp(scale, 'log')
                    % Simple histogram for original model
                    data_x = data.x0s(data.x0s>=-4.1 & data.x0s<=4.1 & data.ves>veThresh);
                    data_sigma = data.sigmas(data.x0s>=-4.1 & data.x0s<=4.1 & data.ves>veThresh);
                elseif (contains(modelName, 'original') || contains(modelName, 'ggfit')) && ~contains(modelName, 'Mirrored') && strcmp(scale, 'lin')
                    fwhms2 = data.sigmas .* (2*sqrt(2*log(2)));
                    fwhms3 = sinh(data.x0s + fwhms2./2) - sinh(data.x0s - fwhms2./2);
                    data.x0s = sinh(data.x0s);
                    data_x = data.x0s(data.x0s>=-22 & data.x0s<=22 & data.ves>veThresh);                    
                    data_sigma = fwhms3(data.x0s>=-22 & data.x0s<=22 & data.ves>veThresh);
                    
                elseif contains(modelName, 'Mirrored') && contains(modelName, 'original')
        
                    validIdx = data.x0s > -10 & data.x0s < 10 & data.ves > veThresh;
                    data_x  = data.x0s(validIdx);
        
        
        
                elseif contains(modelName, 'Mirrored') && ~contains(modelName, 'original')
                    validIdx = data.x0s > -25 & data.x0s < 25 & data.ves > veThresh;
                    data_x  = data.x0s(validIdx);        
                
                else
                    % Weighted bar plot
                    binEdges   = -25:1:25;
                    binCenters = binEdges(1:end-1) + diff(binEdges)/2;
        
                    validIdx = data.x0s > -25 & data.x0s < 25 & data.ves > veThresh;
                    xVals = data.x0s(validIdx);
                    data_x=xVals;
                    veVals = data.ves(validIdx);
        
                    avgVE = zeros(size(binCenters));
                    for i = 1:length(binCenters)
                        inBin = xVals >= binEdges(i) & xVals < binEdges(i+1);
                        if any(inBin)
                            avgVE(i) = sum(veVals(inBin)); % or mean(veVals(inBin))
                            avgVE2(i) = sum(xVals(inBin)); % or mean(veVals(inBin))
                        end
                    end
        
                    weighted_ve = 1 .* avgVE;
                    weighted2_vebynum = avgVE2 .* avgVE;
                end
                % make column vectors
                data_x = data_x(:);
                data_sigma = data_sigma(:);

                % use the SAME voxel set for pref and sigma
                validBoth = ~isnan(data_x) & ~isnan(data_sigma);

                x = data_x(validBoth);
                s = data_sigma(validBoth);

                pref{ptc, whichMap, whichHemi, dt} = x;
                sigma{ptc, whichMap, whichHemi, dt} = s;

                stats{ptc, whichMap, whichHemi, dt} = struct();
                stats{ptc, whichMap, whichHemi, dt}.n = numel(data_x);      % before joint NaN removal
                stats{ptc, whichMap, whichHemi, dt}.nValid = numel(x);      % after joint NaN removal

                if isempty(x)
                    % return NaNs if no data
                    fns = {'medianPref','IQRPref','medianSigma','IQRSigma'};
                    for i = 1:numel(fns)
                        stats{ptc, whichMap, whichHemi, dt}.(fns{i}) = NaN;
                    end
                    continue;
                end

                % clamp preference only
                x = max(min(x, R(2)), R(1));

                % 1) centre
                stats{ptc, whichMap, whichHemi, dt}.medianPref = median(x);
                
                % 2) spread
                stats{ptc, whichMap, whichHemi, dt}.IQRPref = iqr(x);
               
                % 3) sigma
                stats{ptc, whichMap, whichHemi, dt}.mediansigma = median(s);

            end
        end
    end
end
end
