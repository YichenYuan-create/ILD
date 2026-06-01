function results = runILDMetricStats(dataL, dataR, subjectNamesUsed, mapNames, opts)

% runILDMetricStats
%
% Inputs
%   dataL             : nSub x nROI
%   dataR             : nSub x nROI
%   subjectNamesUsed  : nSub subject labels corresponding exactly to rows
%   mapNames          : 1 x nROI ROI labels
%   opts              : optional struct
%
% Main useful options:
%   opts.metricName                   = 'median' / 'iqr' / 'w_contra' / ...
%   opts.signrankCenter              = 0 or 1/3
%   opts.doLME                       = true/false
%   opts.includeHemisphereInLME      = true/false
%   opts.doClassicalANOVA            = true/false
%   opts.includeHemisphereInClassicalANOVA = true/false
%   opts.doSignrank                  = true/false
%   opts.doFDR                       = true/false
%
% Example:
%   statsRes = runILDMetricStats(dataL, dataR, subjectNamesUsed, mapNames, opts);

    if nargin < 5 || isempty(opts)
        opts = struct();
    end

    opts = fillDefaultOpts_runILDMetricStats(opts);

    % -------------------------
    % size checks
    % -------------------------
    [nSub, nROI] = size(dataL);

    if ~isequal(size(dataR), [nSub, nROI])
        error('dataR must have the same size as dataL.');
    end

    if numel(subjectNamesUsed) ~= nSub
        error('Length of subjectNamesUsed (%d) must match size(dataL,1) (%d).', ...
            numel(subjectNamesUsed), nSub);
    end

    if numel(mapNames) ~= nROI
        error('Length of mapNames (%d) must match size(dataL,2) (%d).', ...
            numel(mapNames), nROI);
    end

    subjectNamesUsed = string(subjectNamesUsed(:));
    mapNames = string(mapNames(:));

    % -------------------------
    % build 3D array
    % -------------------------
    metricData = nan(nSub, nROI, 2);
    metricData(:,:,1) = dataL;
    metricData(:,:,2) = dataR;

    [nSub, nROI, nHemi] = size(metricData);
    assert(nHemi == 2, 'Expecting 2 hemispheres.');

    % labels
    subjectIdxLabels = repmat((1:nSub)', [1, nROI, nHemi]);
    mapLabels        = repmat(reshape(1:nROI, 1, nROI, 1), [nSub, 1, nHemi]);
    hemiLabels       = repmat(reshape(1:nHemi, 1, 1, nHemi), [nSub, nROI, 1]);

    hemiNames = opts.hemiNames;
    hemiNameLabels = string(hemiNames(hemiLabels(:)))';

    subjectLabelsStr = subjectNamesUsed(subjectIdxLabels(:));
    mapNameLabels    = mapNames(mapLabels(:));

    results = struct();
    results.data = metricData;
    results.metricName = opts.metricName;

    % =========================================================
    % 1) LME
    % =========================================================
    if opts.doLME
        if opts.includeHemisphereInLME
            data_lme = table( ...
                metricData(:), ...
                categorical(subjectLabelsStr), ...
                categorical(mapNameLabels), ...
                categorical(hemiNameLabels), ...
                'VariableNames', {'metric','subject','map','hemisphere'});

            lmeFormula = 'metric ~ map * hemisphere + (1|subject)';
        else
            data_lme = table( ...
                metricData(:), ...
                categorical(subjectLabelsStr), ...
                categorical(mapNameLabels), ...
                'VariableNames', {'metric','subject','map'});

            lmeFormula = 'metric ~ map + (1|subject)';
        end

        lme = fitlme(data_lme, ...
            lmeFormula, ...
            'DummyVarCoding', opts.DummyVarCoding, ...
            'FitMethod', opts.FitMethod);

        anova_stats = anova(lme, 'dfmethod', opts.dfmethod);

        F   = anova_stats.FStat;
        df1 = anova_stats.DF1;
        df2 = anova_stats.DF2;
        partial_eta2 = (F .* df1) ./ (F .* df1 + df2);

        anova_stats.partial_eta2 = partial_eta2;

        results.data_lme = data_lme;
        results.lme = lme;
        results.lmeFormula = lmeFormula;
        results.anova_stats = anova_stats;

        if opts.displayTables
            disp(anova_stats);
        end
    end

    % =========================================================
    % 2) Classical ANOVA
    % =========================================================
    if opts.doClassicalANOVA
        if opts.makeAnovaFigure
            figure;
        end

        if opts.includeHemisphereInClassicalANOVA
            [p_anovan, T, statsOut] = anovan(metricData(:), ...
                {mapNameLabels, hemiNameLabels, subjectLabelsStr}, ...
                'varnames', {'map', 'hemi', 'subject'}, ...
                'display', opts.anovanDisplay);
        else
            [p_anovan, T, statsOut] = anovan(metricData(:), ...
                {mapNameLabels, subjectLabelsStr}, ...
                'varnames', {'map', 'subject'}, ...
                'display', opts.anovanDisplay);
        end

        row_map   = find(strcmp(T(2:end,1), 'map')) + 1;
        row_error = find(strcmp(T(2:end,1), 'Error')) + 1;

        SS_map   = T{row_map,   2};
        df_map   = T{row_map,   3};
        MS_map   = T{row_map,   5};
        F_map    = T{row_map,   6};
        p_map    = T{row_map,   7};

        SS_error = T{row_error, 2};
        df_error = T{row_error, 3};
        MS_error = T{row_error, 5};

        partial_eta2_map = SS_map / (SS_map + SS_error);

        [multcomp, ~, ~, gnames] = multcompare(statsOut, ...
            'Dimension', 1, ...
            'Display', opts.multcompareDisplay);

        n_i = accumarray(grp2idx(categorical(mapNameLabels)), 1);
        MSE = MS_error;
        df  = df_error;

        q = zeros(size(multcomp,1),1);
        d = zeros(size(multcomp,1),1);

        for k = 1:size(multcomp,1)
            i = multcomp(k,1);
            j = multcomp(k,2);
            diff_ij = multcomp(k,4);

            SE = sqrt(MSE * (1/n_i(i) + 1/n_i(j)));
            q(k) = abs(diff_ij) / SE;

            d(k) = diff_ij / sqrt(MSE);
        end

        % optional: append effect size columns just like your old code
        if opts.appendPairwiseToMultcomp
            multcomp(:,7) = q;
            multcomp(:,8) = d;
        end

        results.p_anovan = p_anovan;
        results.T = T;
        results.statsOut = statsOut;
        results.classical = struct( ...
            'SS_map', SS_map, ...
            'df_map', df_map, ...
            'MS_map', MS_map, ...
            'F_map', F_map, ...
            'p_map', p_map, ...
            'SS_error', SS_error, ...
            'df_error', df_error, ...
            'MS_error', MS_error, ...
            'partial_eta2_map', partial_eta2_map);

        results.multcomp = multcomp;
        results.gnames = gnames;
        results.pairwise = struct( ...
            'q', q, ...
            'd', d, ...
            'df', df, ...
            'MSE', MSE, ...
            'n_i', n_i);
    end

    % =========================================================
    % 3) Signrank across collapsed hemispheres
    % =========================================================
    if opts.doSignrank
        rankData = nan(nSub * 2, nROI);

        for roiIdx = 1:nROI
            rankData(:, roiIdx) = [dataL(:, roiIdx); dataR(:, roiIdx)];
        end

        p_signrank = nan(1, nROI);
        z = nan(1, nROI);
        n_eff = nan(1, nROI);
        stats_t = cell(1, nROI);

        for roiIdx = 1:nROI
            thisData = rankData(:, roiIdx);
            thisData = thisData(~isnan(thisData));
            thisData = thisData - opts.signrankCenter;

            [p_signrank(roiIdx), ~, stats_t{roiIdx}] = signrank(thisData);

            if isfield(stats_t{roiIdx}, 'zval')
                z(roiIdx) = stats_t{roiIdx}.zval;
            end

            n_eff(roiIdx) = sum(thisData ~= 0);
        end

        if opts.doFDR
            [~, ~, ~, adj_p] = fdr_bh(p_signrank);
        else
            adj_p = nan(size(p_signrank));
        end

        allDataRank = rankData(:);
        allDataRank = allDataRank(~isnan(allDataRank));
        allDataRank = allDataRank - opts.signrankCenter;

        [p_all, ~] = signrank(allDataRank);
        r_effect = z ./ sqrt(n_eff);

        results.signrank = struct( ...
            'rankData', rankData, ...
            'p_signrank', p_signrank, ...
            'stats_t', {stats_t}, ...
            'z', z, ...
            'n_eff', n_eff, ...
            'adj_p', adj_p, ...
            'p_all', p_all, ...
            'r_effect', r_effect, ...
            'center', opts.signrankCenter);
    end
end