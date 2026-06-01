function ILDPreferenceHist(dataStruct, subjID, mapNames, hemispheres, modelNames, whichModel, DTnames, whichDT, veThresh,scale,exp)
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

fig = figure('Color', 'w'); hold on;

for whichMap = 1:length(mapNames)
    mapName = mapNames{whichMap};

    % Check if ROI exists
    if ~isfield(dataStruct.(subjID), mapName), continue; end
    mapStruct = dataStruct.(subjID).(mapName);

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

        subplot(numel(hemispheres), length(mapNames), ...
            (whichHemi-1)*length(mapNames) + whichMap);

        if (contains(modelName, 'original') && ~contains(modelName, 'Mirrored')) || (contains(modelName, 'ggfit') && ~contains(modelName, 'Mirrored'))
            % Simple histogram for original model
            if strcomp(scale,'log')==1
                % data_x = data.x0s(data.x0s>-4.1 & data.x0s<4.1 & data.ves>veThresh);
                % histogram(data_x, -4.1:0.1:4.1, 'FaceColor','none');
                % axis square;
                % xlim([-4.1 4.1]);
                if contains(DTname,'Monaural')
                    data_x = data.x0s(data.x0s > -5.4 & data.x0s < 5.4 & data.ves > veThresh);
                    histogram(data_x, -5.4:0.1:5.4, 'FaceColor','none');
                    axis square;
                    xlim([-5.4 5.4]);
                    set(gca,'Box','on','TickDir','in','LineWidth',1.2)
                    % xlabel('ILD value')
                    % ylabel('Count')
                    xticks(asinh([-110     0    110]))
                    xticklabels([-110    0     110])
                else
                    data_x = data.x0s(data.x0s > -4.1 & data.x0s < 4.1 & data.ves > veThresh);
                    histogram(data_x, -4.1:0.1:4.1, 'FaceColor','none');
                    axis square;
                    xlim([-4.1 4.1]);
                    set(gca,'Box','on','TickDir','in','LineWidth',1.2)
                    % xlabel('ILD value')
                    % ylabel('Count')
                    xticks(asinh([-22  -8    0   8  22]))
                    xticklabels([-22  -8   0    8  22])
                end
                % title([mapName ' ' hemiName], 'Interpreter','none')
                % set(fig,'PaperPositionMode','auto');
                % set(fig,'Renderer','painters');   % vector
                % if exp
                %     filename = 'histogram_log.pdf';
                %     exportgraphics(fig, filename, ...
                %         'Append', false, ...
                %         'ContentType', 'vector');
                % end
            elseif strcomp(scale,'lin')==1
                % data.x0s = sinh(data.x0s);
                % data_x = data.x0s(data.x0s>-25 & data.x0s<25 & data.ves>veThresh);
                % histogram(data_x, -25:1:25, 'FaceColor','none');
                % axis square;
                % xlim([-25 25]);
                if contains(DTname,'Monaural')
                    data.x0s = sinh(data.x0s);
                    data_x = data.x0s(data.x0s > -110 & data.x0s < 110 & data.ves > veThresh);
                    histogram(data_x, linspace(-110,110,83), 'FaceColor','none'); % originally -25:1:25
                    axis square;
                    xlim([-110 110]);
                    set(gca,'Box','on','TickDir','in','LineWidth',1.2)
                    % xlabel('ILD (dB)')
                    % ylabel('Voxel count')
                    % title('Histogram of preferred ILD (linear space)')
                    xticks([-110    0    110])
                else
                    data.x0s = sinh(data.x0s);
                    data_x = data.x0s(data.x0s > -25 & data.x0s < 25 & data.ves > veThresh);
                    histogram(data_x, linspace(-25,25,83), 'FaceColor','none'); % originally -25:1:25
                    axis square;
                    xlim([-25 25]);
                    set(gca,'Box','on','TickDir','in','LineWidth',1.2)
                    % xlabel('ILD (dB)')
                    % ylabel('Voxel count')
                    % title('Histogram of preferred ILD (linear space)')
                    xticks([-22 -8    0   8  22])
                end
                % set(fig,'PaperPositionMode','auto');
                % set(fig,'Renderer','painters');
                % if exp
                %     exportgraphics(fig, 'histogram_linear.pdf', ...
                %         'ContentType','vector');
                % end
            end
        elseif contains(modelName, 'Mirrored') && contains(modelName, 'original')
            binEdges   = -4.1:0.1:4.1;
            binCenters = binEdges(1:end-1) + diff(binEdges)/2;

            validIdx = data.x0s > -10 & data.x0s < 10 & data.ves > veThresh;
            xVals  = data.x0s(validIdx);
            xVals2 = -data.x0s(validIdx);
            veVals = data.ves(validIdx);
            ratio = (data.betas(validIdx,1)./(data.betas(validIdx,1)+data.betas(validIdx,2)))';

            avgVE = zeros(size(binCenters));
            for i = 1:length(binCenters)
                inBin = xVals >= binEdges(i) & xVals < binEdges(i+1);
                inBin2 = xVals2 >= binEdges(i) & xVals2 < binEdges(i+1);

                if any(inBin)

                    avgVE(i) = sum(xVals(inBin).*ratio(inBin).*veVals(inBin)); % or mean(veVals(inBin))
                    % avgVE(i) = sum(xVals(inBin)); % or mean(veVals(inBin))
                end
                if any(inBin2) 
                    avgVE(i) = -sum(xVals2(inBin2).*(1-ratio(inBin2)).*veVals(inBin2));  %.*ratio(inBin2)); % or mean(veVals(inBin))
                    % avgVE(i) = sum(xVals(inBin)); % or mean(veVals(inBin))
                end
            end

            weighted = 1 .* avgVE;
            bar(binCenters, weighted, 1, 'FaceColor','none');
            axis square;
            % xlim([-25 25]);

        elseif contains(modelName, 'Mirrored') && ~contains(modelName, 'original')
            binEdges   = -25:1:25;
            binCenters = binEdges(1:end-1) + diff(binEdges)/2;

            validIdx = data.x0s > -25 & data.x0s < 25 & data.ves > veThresh;
            xVals  = data.x0s(validIdx);
            xVals2 = -data.x0s(validIdx);
            veVals = data.ves(validIdx);
            ratio = (data.betas(validIdx,1)./(data.betas(validIdx,1)+data.betas(validIdx,2)))';

            avgVE = zeros(size(binCenters));
            for i = 1:length(binCenters)
                inBin = xVals >= binEdges(i) & xVals < binEdges(i+1);
                inBin2 = xVals2 >= binEdges(i) & xVals2 < binEdges(i+1);

                if any(inBin)

                    avgVE(i) = sum(xVals(inBin).*ratio(inBin).*veVals(inBin)); % or mean(veVals(inBin))
                    % avgVE(i) = sum(xVals(inBin)); % or mean(veVals(inBin))
                end
                if any(inBin2) 
                    avgVE(i) = -sum(xVals2(inBin2).*(1-ratio(inBin2)).*veVals(inBin2));  %.*ratio(inBin2)); % or mean(veVals(inBin))
                    % avgVE(i) = sum(xVals(inBin)); % or mean(veVals(inBin))
                end
            end

            weighted = 1 .* avgVE;
            bar(binCenters, weighted, 1, 'FaceColor','none');
            axis square;
            % xlim([-25 25]);
        
        
        else
            % data_x = data.x0s(data.x0s>-25 & data.x0s<25 & data.ves>veThresh);
            % h=histogram(data_x, -25:25, 'FaceColor', 'none');
            % axis square;
            % xlim([-25 25]);
            % Weighted bar plot
            binEdges   = -25:1:25;
            binCenters = binEdges(1:end-1) + diff(binEdges)/2;

            validIdx = data.x0s > -25 & data.x0s < 25 & data.ves > veThresh;
            xVals = data.x0s(validIdx);
            veVals = data.ves(validIdx);

            avgVE = zeros(size(binCenters));
            for i = 1:length(binCenters)
                inBin = xVals >= binEdges(i) & xVals < binEdges(i+1);
                if any(inBin)
                    avgVE(i) = sum(veVals(inBin)); % or mean(veVals(inBin))
                    % avgVE(i) = sum(xVals(inBin)); % or mean(veVals(inBin))
                end
            end

            weighted = 1 .* avgVE;
            bar(binCenters, weighted, 1, 'FaceColor','none');
            xticks([-20 -10 0 10 20]);
            axis square;
            xlim([-25 25]);
        end

        title(sprintf('%s %s', hemiName, mapName));
        % 
        % % result_ILD{whichMap,whichHemi}.data = data;
        % if contains(modelName, 'original')
        %     result_ILD(whichMap,whichHemi,:) = data_x;
        % else
        %     result_ILD(whichMap,whichHemi,:) = xVals;
        % end

    end
end
% set(fig,'PaperPositionMode','auto');
% set(fig,'Renderer','painters');

if exp
    filename = sprintf('histogram_%s_full.pdf', scale);
    exportgraphics(fig, filename, ...
        'ContentType','vector');
end
end
