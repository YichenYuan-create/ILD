function plotGlobalGMM(pooled, gm, opts)

pooled = pooled(:);

figure('Color','w'); hold on;

% -------- 1. histogram: voxel counts --------
h = histogram(pooled, opts.histBins, ...
    'Normalization','count', ...
    'EdgeColor','none');

% -------- 2. x range --------
xx = linspace(min(pooled), max(pooled), 500);

% -------- 3. parameters --------
mu = gm.mu;
sigma = sqrt(squeeze(gm.Sigma));   % variance -> std
w = gm.ComponentProportion;

% -------- 4. scaling factor --------
N = numel(pooled);
binWidth = h.BinWidth;   % safer than manual

% -------- 5. plot 3 global Gaussian components --------
for k = 1:length(mu)
    y = w(k) * normpdf(xx, mu(k), sigma(k));
    y = y * N * binWidth;   % ⭐ convert density → counts
    plot(xx, y, '--', 'LineWidth', 1.5);
end

% -------- 6. plot full mixture --------
mix = zeros(size(xx));
for k = 1:length(mu)
    mix = mix + w(k) * normpdf(xx, mu(k), sigma(k));
end
mix = mix * N * binWidth;

plot(xx, mix, 'k-', 'LineWidth', 2);

% -------- 7. labels --------
xlabel('ILD preference');
ylabel('Number of voxels');
title('Global GMM fit (voxel counts)');

box off;