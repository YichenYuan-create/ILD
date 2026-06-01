function metricMat = extractTuningWidthMetric(stats_allptc, fieldName, colIdx)

    nSub = numel(stats_allptc);

    % find first non-empty subject to get number of rows
    nRows = [];
    for i = 1:nSub
        if ~isempty(stats_allptc{i}) && isfield(stats_allptc{i}, fieldName)
            nRows = size(stats_allptc{i}.(fieldName), 1);
            break;
        end
    end

    if isempty(nRows)
        error('Could not find field "%s" in stats_allptc.', fieldName);
    end

    metricMat = nan(nSub, nRows);

    for i = 1:nSub
        if isempty(stats_allptc{i}) || ~isfield(stats_allptc{i}, fieldName)
            continue;
        end

        thisMat = stats_allptc{i}.(fieldName);

        if size(thisMat,2) < colIdx
            error('Field "%s" does not have column %d.', fieldName, colIdx);
        end

        metricMat(i,:) = thisMat(:, colIdx)';
    end
end