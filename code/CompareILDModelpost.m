function results = CompareILDModelpost(barDataMeans, subjectOrder, mapNames, model1, model2, ModelNamesFig, opts)
% CompareILDModelStats
% Post-hoc analysis of model differences using LME, ANOVA, violin plots, and signrank tests.
%
% INPUTS
%   barDataMeans : array [subj × map × hemi × split × model]
%   subjectOrder : cell/string array of subject IDs
%   mapNames     : cell/string array of ROI names
%
% OUTPUTS
%   results struct with fields:
%       .TunedMonoDif   : difference array
%       .anova_lme      : fitted LME object
%       .anova_stats    : anova results from LME
%       .anovan_p       : p values from ANOVAN
%       .multcomp       : multiple comparison results
%       .signrank_p     : signrank p per ROI
%       .signrank_adj   : FDR-corrected p per ROI
%       .signrank_all   : signrank p for all ROIs combined
if isempty(opts), opts = struct(); end
% opts = setDefault(opts, 'doExport', true);
% opts = setDefault(opts, 'doExport', false);
opts = setDefault(opts, 'outputPrefix', 'CompareILDModelpost');
opts = setDefault(opts, 'contentType', 'vector');
opts = setDefault(opts, 'truncateFilename', true);
opts = setDefault(opts, 'maxFilenameLen', 220);

% ------------------------------------------------------------------------
% Labels
barDataSizes = size(barDataMeans);
subjectLabels = repmat((1:length(subjectOrder))', [1, barDataSizes(2:end-1)]);
mapLabels     = repmat((1:length(mapNames)), [barDataSizes(1), 1, barDataSizes(3:end-1)]);

% ------------------------------------------------------------------------
% Compute difference (example: model 3 minus model 11)
TunedMonoDif = squeeze(barDataMeans(:,:,:,:,model1) - barDataMeans(:,:,:,:,model2));

% ------------------------------------------------------------------------
% LME (Linear Mixed Effects)
data_lme = table(TunedMonoDif(:), ...
    nominal(subjectLabels(:)), ...
    nominal(mapLabels(:)), ...
    'VariableNames', {'veDif','subject','map'});

anova_lme = fitlme(data_lme,'veDif~map+(1|subject)', ...
    'DummyVarCoding','effects','FitMethod','reml');
anova_stats = anova(anova_lme,'dfmethod','satterthwaite');
F  = anova_stats.FStat;
df1 = anova_stats.DF1;
df2 = anova_stats.DF2;
partial_eta2 = (F .* df1) ./ (F .* df1 + df2);
anova_stats.partial_eta2 = partial_eta2;

% ------------------------------------------------------------------------
% ANOVA (classical)
subjectLabelsStr = subjectOrder(subjectLabels(:));
mapNameLabels    = mapNames(mapLabels(:));

figure;
[p_anovan,T,statsOut] = anovan(TunedMonoDif(:), ...
    {mapNameLabels subjectLabelsStr}, ...
    'varnames', {'map','subject'});
% multcomp = multcompare(statsOut,'Dimension',[1]);
row_map   = find(strcmp(T(2:end,1),'map')) + 1;
row_error = find(strcmp(T(2:end,1),'Error')) + 1;
SS_map   = T{row_map,   2};
df_map   = T{row_map,   3};
MS_map   = T{row_map,   5};
F_map    = T{row_map,   6};
p_map    = T{row_map,   7};
SS_error = T{row_error, 2};
df_error = T{row_error, 3};
MS_error = T{row_error, 5}; 
partial_eta2_map = SS_map / (SS_map + SS_error);

[multcomp,~,~,gnames] = multcompare(statsOut,'Dimension',1);  
n_i = accumarray(grp2idx(categorical(mapNameLabels)), 1);
MSE = MS_error;  
df  = df_error;
q = zeros(size(multcomp,1),1);
t_from_q = zeros(size(multcomp,1),1);
d = zeros(size(multcomp,1),1);        
r = zeros(size(multcomp,1),1);       
for k = 1:size(multcomp,1)
    i = multcomp(k,1); j = multcomp(k,2);
    diff_ij = multcomp(k,4);

    SE = sqrt(MSE * (1/n_i(i) + 1/n_i(j))); 
    q(k) = abs(diff_ij) / SE;

    % t_from_q(k) = q(k) / sqrt(2);

    % effect size（pairwise）
    d(k) = diff_ij / sqrt(MSE);                 
    % r(k) = t_from_q(k) / sqrt(t_from_q(k)^2 + df);
end
multcomp(:,7) = q;
multcomp(:,8) = d;
% ------------------------------------------------------------------------
% Box/Violin plot of differences
% figure; hold on;
% violindata = nan(numel(TunedMonoDif)/numel(mapNames), numel(mapNames));
% for ROI=1:length(mapNames)
%     tmp = TunedMonoDif(:,ROI,:,:);
%     violindata(:,ROI) = tmp(:);
% end
% %boxplot(violindata,'Labels',mapNames);
% violincols=repmat([.5; .5; .5], [1, length(mapNames)]);
% daviolinplot(violindata, 'truncateviolin', 1, 'violin', 'full', 'colors', violincols')%, 'box', 0)
% 
% plot([0.5 length(mapNames)+0.5],[0 0],'k--');
% set(gca, 'XTick', 1:numel(mapNames), ...
%          'XTickLabel', mapNames, ...
%          'TickLabelInterpreter','none');
% xtickangle(45);          % rotate labels
% % xtickangle(90);
% ymax=max([abs(min(TunedMonoDif(:))) abs(max(TunedMonoDif(:)))]);
% ymax = ceil(ymax*10)/10;
% % if model2==5 || model2==8
% %     axis([0.5 length(mapNames)+0.5 -.06 .06])
% % else
%     axis([0.5 length(mapNames)+0.5 -(ymax) ymax])
% % end
% ylabel({'Difference in variance explained','(cross-validated)'});
% axis square;
% title(sprintf('%s vs %s', ModelNamesFig(model1), ModelNamesFig(model2)));
% set(gca, 'Color', 'w');
% set(gcf,'Color','w');
% % markers={'s', 'd'};
% % %cols={'k','r', 'g', 'b', 'c', 'm'};, 'y','w'};
% % cols={[1 0 0], [0 1 0], [0 0 1], [0 1 1], [1 0 1],  [1 0.5 0.5]; [0.5 0 0], [0 0.5 0], [0 0 0.5], [0 0.5 0.5], [0.5 0 0.5], [0.5 0.25 0.25]}
% % 
% baseCols = [
%     0.894 0.102 0.110
%     0.216 0.494 0.722
%     0.302 0.686 0.290
%     0.596 0.306 0.639
%     1.000 0.498 0.000
%     1.000 0.749 0.000
%     0.651 0.337 0.157
%     0.969 0.506 0.749
%     0.200 0.200 0.200
%     ];
% nSub = length(subjectOrder);
% 
% cols = baseCols(1:nSub,:);
% % Overlay subject markers
% markers = {'^','v';'o','d'};
% cols = lines(length(subjectOrder)); % simpler colormap than original
% for participant=1:length(subjectOrder)
%     for hemisphere=1:2
%         for split=1:2
%             for ROI=1:length(mapNames)
%                 plot(ROI, TunedMonoDif(participant,ROI,hemisphere,split), ...
%                     markers{split,hemisphere}, ...
%                     'MarkerEdgeColor',cols(participant,:), ...
%                     'MarkerFaceColor',cols(participant,:));
%             end
%         end
%     end
% end

% Box/Violin plot of differences_latesthalf violins
figure; hold on;

nSub = length(subjectOrder);
nROI = length(mapNames);
nSplit = 2;   % odd / even
nHemi = 2;    % LH / RH

% ------------------------------------------------------------
% Build half-violin data
% left half = LH, right half = RH
% each half violin contains all subjects x 2 splits
% ------------------------------------------------------------
dataL = nan(nSub*nSplit, nROI);
dataR = nan(nSub*nSplit, nROI);

for ROI = 1:nROI
    tmpL = squeeze(TunedMonoDif(:, ROI, 1, :));   % nSub x 2
    tmpR = squeeze(TunedMonoDif(:, ROI, 2, :));   % nSub x 2

    dataL(:, ROI) = tmpL(:);
    dataR(:, ROI) = tmpR(:);
end

% ------------------------------------------------------------
% Plot half violins
% ------------------------------------------------------------
violinColsL = repmat([0.5 0.5 0.5], nROI, 1);
violinColsR = repmat([0.85 0.85 0.85], nROI, 1);

daviolinplot(dataL, ...
    'truncateviolin', 1, ...
    'violin', 'half2', ...
    'colors', violinColsL, ...
    'outliers', 0);

daviolinplot(dataR, ...
    'truncateviolin', 1, ...
    'violin', 'half', ...
    'colors', violinColsR, ...
    'outliers', 0);

% zero line
plot([0.5 nROI+0.5], [0 0], 'k--');

% ------------------------------------------------------------
% Axis formatting
% ------------------------------------------------------------
set(gca, 'XTick', 1:nROI, ...
         'XTickLabel', mapNames, ...
         'TickLabelInterpreter', 'none');
xtickangle(45);

ymax = max(abs(TunedMonoDif(:)));
ymax = ceil(ymax*10)/10;

axis([0.5 nROI+0.5 -ymax ymax]);
ylabel({'Difference in variance explained','(cross-validated)'});
axis square;
title(sprintf('%s vs %s', ModelNamesFig(model1), ModelNamesFig(model2)));
set(gca, 'Color', 'w');
set(gcf, 'Color', 'w');

% ------------------------------------------------------------
% Overlay subject markers
%   half violin side = hemisphere
%   marker shape = split x hemisphere
% ------------------------------------------------------------
markers = {'o','d'; '^','v'};   % {split, hemisphere}
baseCols = [
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

cols = baseCols(1:nSub,:);
% cols = lines(nSub);

offset = 0.08;
xJitter = 0;   % small jitter so odd/even don't overlap perfectly

% for participant = 1:nSub
%     for hemisphere = 1:2
%         for split = 1:2
%             for ROI = 1:nROI
% 
%                 y = TunedMonoDif(participant, ROI, hemisphere, split);
% 
%                 if hemisphere == 1
%                     x = ROI - offset + (rand-0.5)*2*xJitter;   % LH on left half
%                 else
%                     x = ROI + offset + (rand-0.5)*2*xJitter;   % RH on right half
%                 end
% 
%                 plot(x, y, ...
%                     markers{split, hemisphere}, ...
%                     'MarkerEdgeColor', cols(participant,:), ...
%                     'MarkerFaceColor', cols(participant,:), ...
%                     'MarkerSize', 6, ...
%                     'LineWidth', 1);
%             end
%         end
%     end
% end
for participant = 1:nSub
    for hemisphere = 1:2
        for split = 1:2
            for ROI = 1:nROI

                y = TunedMonoDif(participant, ROI, hemisphere, split);

                % ---------------- hemisphere → marker ----------------
                if hemisphere == 1
                    x = ROI - offset;
                    marker = 'o';   % LH
                else
                    x = ROI + offset;
                    marker = 'd';   % RH
                end

                % ---------------- split → fill ----------------
                if split == 1
                    faceColor = cols(participant,:);   % filled
                else
                    faceColor = 'none';               % empty
                end

                plot(x, y, marker, ...
                    'MarkerEdgeColor', cols(participant,:), ...
                    'MarkerFaceColor', faceColor, ...
                    'MarkerSize', 6, ...
                    'LineWidth', 1);
            end
        end
    end
end


% ------------------------------------------------------------------------
% Signrank tests (per ROI and overall)
p_signrank = nan(1,length(mapNames));
for n=1:length(mapNames)
    [p_signrank(n), ~, stats_t{n}] = signrank(TunedMonoDif(mapLabels==n));
    z(n) = stats_t{n}.zval;
    n_eff2(n)      = sum(TunedMonoDif(mapLabels==n) ~= 0);
end
% [~,~,~,adj_p] = fdr_bh(p_signrank); % FDR correction
% [p_all,~] = signrank(TunedMonoDif(:));
[~,~,~,adj_p] = fdr_bh(p_signrank); % FDR correction
[p_all,~] = signrank(TunedMonoDif(:));
r_effect2 = z ./ sqrt(n_eff2);

% ------------------------------------------------------------------------
% Output struct
results = struct();
results.compnames    = sprintf('%s vs %s', ModelNamesFig(model1), ModelNamesFig(model2));
results.TunedMonoDif = TunedMonoDif;
results.anova_lme    = anova_lme;
results.anova_stats  = anova_stats;
results.anovan_p     = p_anovan;
results.anovan_effectsize     = partial_eta2_map;
results.multcomp     = multcomp;
results.signrank_z   = z;
results.signrank_n_eff2   = n_eff2;
results.signrank_p   = p_signrank;
results.signrank_adj = adj_p;
results.signrank_all = p_all;
results.signrank_effectsize = r_effect2;

if opts.doExport
    
    prefs = 1;       
    ves   = 2; 
    fwhms = 3;
    % set(fig,'PaperPositionMode','auto');
    % set(fig,'Renderer','painters');   % best for vector

    outputPDF = buildFilename(opts.outputPrefix, prefs, ves, fwhms, opts);
    
    exportgraphics(gcf, outputPDF, ...
        'Append', false, ...
        'ContentType', opts.contentType);
end


end
