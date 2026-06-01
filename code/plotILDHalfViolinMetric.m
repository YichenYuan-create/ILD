function plotILDHalfViolinMetric(dataL, dataR, mapNames_plot, cols, opts)

% plotILDHalfViolinMetric
%
% Inputs
%   dataL         : nSub x nROI
%   dataR         : nSub x nROI
%   mapNames_plot : 1 x nROI labels
%   cols          : nROI x 3 colors
%   opts          : plotting options
%
% Example
%   opts = struct();
%   opts.figname = 'IQR_lin.pdf';
%   opts.ylim = [0 30];
%   plotILDHalfViolinMetric(dataL, dataR, mapNames_plot, cols, opts);

    if nargin < 5 || isempty(opts)
        opts = struct();
    end

    opts = fillDefaultOpts_plotILDHalfViolinMetric(opts, dataL, mapNames_plot);

    [nSub, nROI] = size(dataL);

    if ~isequal(size(dataR), [nSub, nROI])
        error('dataR must have the same size as dataL.');
    end

    if numel(mapNames_plot) ~= nROI
        error('Length of mapNames_plot (%d) must match number of ROI columns (%d).', ...
            numel(mapNames_plot), nROI);
    end

    if size(cols,1) ~= nROI || size(cols,2) ~= 3
        error('cols must be an nROI x 3 color matrix.');
    end

    Plothalfviolin(dataL, dataR, cols, nROI, nSub, mapNames_plot, opts);

end