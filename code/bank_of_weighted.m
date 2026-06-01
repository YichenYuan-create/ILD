
% % only change one exponent, fixed the other exponent and weight
x = dB_left;                     
xNorm = x;
dB_left  = fliplr(x);
dB_right = x;

alphaL_vals = 0:0.1:1;
alphaR_fixed = 0.5;
weight = 0.7;

figure; hold on;
colours = parula(length(alphaL_vals));

for i = 1:length(alphaL_vals)
    alphaL = alphaL_vals(i);
    R = (1-weight) *(dB_left.^alphaL) + ...
         weight* (dB_right.^alphaR_fixed);
    % R = R ./ max(R);
    R = (R - min(R)) ./ (max(R) - min(R));
    plot(x, R, 'LineWidth', 2, ...
        'Color', colours(i,:), ...
        'DisplayName', ['\alpha_L = ' num2str(alphaL)]);
end

xlabel('Normalized stimulus');
ylabel('Normalized response');
title(['Fixed \alpha_R = ' num2str(alphaR_fixed)]);
colorbar;
box on;

%% red-bule

% -----------------------------
% Inputs (your original setup)
% -----------------------------
xLinMono = 56:1:78;     % you can adjust range as needed
xLinMono = (xLinMono - min(xLinMono)) ./ ...
        (max(xLinMono) - min(xLinMono));% Range of compression exponents
dB_left  = fliplr(xLinMono);   % left channel
dB_right = xLinMono;           % right channel

x = dB_left;
xNorm = x; %#ok<NASGU>  % keep if you still need it elsewhere
dB_left  = fliplr(x);
dB_right = x;

alphaL_vals   = 0:0.1:1;
alphaR_fixed  = 0.5;

weights = [0.2 0.5 0.8];

Rmin = +inf;
Rmax = -inf;

for b = 1:numel(weights)
    w = weights(b);
    for i = 1:numel(alphaL_vals)
        alphaL = alphaL_vals(i);

        Rtmp = (dB_left.^alphaL) + w * (dB_right.^alphaR_fixed);

        % force scalar min/max
        Rmin = min(Rmin, min(Rtmp(:)));
        Rmax = max(Rmax, max(Rtmp(:)));
    end
end

% safety
den = Rmax - Rmin;
if den <= 0
    error('Global normalization failed: Rmax <= Rmin.');
end

% "Contrast" scales: 1 = full colour, 0 = white
colorscale1 = 0.85;
colorscale2 = 0.50;
colorscale3 = 0.20;
colorScales = [colorscale1 colorscale2 colorscale3];

% -----------------------------
% Base blue->red colormap (same hue for all banks)
% -----------------------------
nC = numel(alphaL_vals);
blue = [0 0.2 0.8];
red  = [0.8 0 0];

cmapBR = [ ...
    linspace(blue(1), red(1), nC)', ...
    linspace(blue(2), red(2), nC)', ...
    linspace(blue(3), red(3), nC)'  ...
];

% -----------------------------
% Plot
% -----------------------------
figure; hold on; box on;

for b = 1:numel(weights)
    w  = weights(b);
    cs = colorScales(b);

    for i = 1:nC
        alphaL = alphaL_vals(i);

        R = (dB_left.^alphaL) + w * (dB_right.^alphaR_fixed);
        R = (R - Rmin) ./ den;
        % "Make it X% coloured, rest white"
        colorTrip = cmapBR(i,:);
        lineCol = [1 1 1] - ([1 1 1] - colorTrip) * cs;

        % Optional: slightly different linewidth per bank to help separation
        % (or keep fixed)
        lw = 2;  % or e.g., lw = 2.2 - 0.4*(b-1);

        plot(x, R, ...
            'LineWidth', lw, ...
            'Color', lineCol, ...
            'HandleVisibility', 'off'); % avoid huge legend
    end
end

xlabel('Normalized stimulus');
ylabel('Normalized response');
title(sprintf('Three banks: \\alpha_R fixed = %.2f; weights = [%.1f %.1f %.1f]', ...
    alphaR_fixed, weights(1), weights(2), weights(3)));

% -----------------------------
% Colourbar: show the base blue->red mapping for alphaL
% -----------------------------
colormap(cmapBR);
cb = colorbar;
cb.Ticks = linspace(0,1,numel(alphaL_vals));
cb.TickLabels = arrayfun(@(a) sprintf('%.1f', a), alphaL_vals, 'UniformOutput', false);
cb.Label.String = '\alpha_L (blue \rightarrow red)';

% -----------------------------
% Minimal legend for the 3 banks (draw 3 dummy lines)
% -----------------------------
bankCols = [ ...
    [1 1 1] - ([1 1 1] - blue)*colorscale1; ...
    [1 1 1] - ([1 1 1] - blue)*colorscale2; ...
    [1 1 1] - ([1 1 1] - blue)*colorscale3  ...
];
hLeg = gobjects(1, numel(weights));
for b = 1:numel(weights)
    hLeg(b) = plot(nan, nan, 'LineWidth', 3, 'Color', bankCols(b,:));
end
legend(hLeg, ...
    arrayfun(@(w) sprintf('weight = %.1f', w), weights, 'UniformOutput', false), ...
    'Location', 'best');

%% examples
pairs = [ ...
    0.2 0.8;
    0.8 0.2;
    0.5 0.5;
    0.9 0.9];

figure;
for i = 1:size(pairs,1)
    alphaL = pairs(i,1);
    alphaR = pairs(i,2);

    R = (dB_left.^alphaL) + weight*(dB_right.^alphaR);
    R = R ./ max(R);

    subplot(2,2,i);
    plot(x, R, 'LineWidth', 2);
    title(['\alpha_L=' num2str(alphaL) ...
           ', \alpha_R=' num2str(alphaR)]);
    axis([0 1 0 1]);
end



%% add weight
% fixed exponent, change weight

alphaL = 0.4;
alphaR = 0.8;
weights = 0:0.2:1;

figure; hold on;
colours = parula(length(weights));

for i = 1:length(weights)
    w = weights(i);
    R = (dB_left.^alphaL) + w*(dB_right.^alphaR);
    R = R ./ max(R);
    plot(xNorm, R, 'LineWidth', 2, ...
        'Color', colours(i,:), ...
        'DisplayName', ['w=' num2str(w)]);
end

xlabel('Stimulus');
ylabel('Normalized response');
title(['Fixed \alpha_L=' num2str(alphaL) ...
       ', \alpha_R=' num2str(alphaR)]);
colorbar;

%% fixed weight, change exponent
alphaL = 0:0.05:1;
alphaR = 0:0.05:1;
[xL, xR] = meshgrid(alphaL, alphaR);

x0 = 0.7;   % 选一个代表性的 stimulus
dB_L0 = 1 - x0;
dB_R0 = x0;
weight = 0.7;

R = (dB_L0.^xL) + weight * (dB_R0.^xR);

figure;
imagesc(alphaL, alphaR, R);
set(gca,'YDir','normal');
xlabel('\alpha_L');
ylabel('\alpha_R');
title(['Response at stimulus x = ' num2str(x0)]);
colorbar;
axis square;


%% example
pairs = [ ...
    0.2 0.8;
    0.8 0.2;
    0.5 0.5;
    0.1 0.1;
    0.9 0.9];

weights = [0.2 0.5 0.8];   

nPairs = size(pairs,1);
nW = length(weights);

figure;
for i = 1:nPairs
    alphaL = pairs(i,1);
    alphaR = pairs(i,2);

    for j = 1:nW
        w = weights(j);

        R = (dB_left.^alphaL) + w*(dB_right.^alphaR);
        R = R ./ max(R);

        subplot(nPairs, nW, (i-1)*nW + j);
        plot(xNorm, R, 'LineWidth', 2);
        axis([0 1 0 1]);

        if i == 1
            title(['w = ' num2str(w)]);
        end
        if j == 1
            ylabel(['\alpha_L=' num2str(alphaL) ...
                    ', \alpha_R=' num2str(alphaR)]);
        end
    end
end

sgtitle('Compressive weighted model: exponent pairs × weight');





%
pairs = [ ...
    0.2 0.8;
    0.8 0.2;
    0.5 0.5;
    0.1 0.1;
    0.9 0.9];

weights = [0.2 0.5 0.8];   

nPairs = size(pairs,1);
nW = length(weights);

Rall = [];

for i = 1:nPairs
    alphaL = pairs(i,1);
    alphaR = pairs(i,2);

    for j = 1:nW
        w = weights(j);

        R = (1-w)*(dB_left.^alphaL) + w*(dB_right.^alphaR);
        Rall = [Rall; R(:)];
    end
end

Rmin = min(Rall);
Rmax = max(Rall);
fig = figure('Color','w');   % figure 
ax = gca;
ax.Color = 'w'; 
hold on;
for i = 1:nPairs
    alphaL = pairs(i,1);
    alphaR = pairs(i,2);

    for j = 1:nW
        w = weights(j);

        R = (1-w)*(dB_left.^alphaL) + w*(dB_right.^alphaR);

        % global 0-1
        % R = (R - Rmin) ./ (Rmax - Rmin); 
        % subplot [0,1]
        R = (R - min(R)) ./ (max(R) - min(R));   

        subplot(nPairs, nW, (i-1)*nW + j);
        plot(xNorm, R, 'LineWidth', 2, 'Color','b');
        ylim([0 1]);
        xlim([0 1]);
        box off;
        axis square
        set(gca,'Box','off','TickDir','in','LineWidth',1.2)
        set(fig,'PaperPositionMode','auto');
        set(fig,'Renderer','painters');   % best for vector
        if i == 1
            title(['w = ' num2str(w)]);
        end
        if j == 1
            ylabel(['\alpha_L=' num2str(alphaL) ...
                    ', \alpha_R=' num2str(alphaR)]);
        end
    end
end

sgtitle('Compressive weighted model: exponent pairs × weight');

% axis square
% set(gca,'Box','off','TickDir','in','LineWidth',1.2)
% set(fig,'PaperPositionMode','auto');
% set(fig,'Renderer','painters');   % best for vector
filename = 'bank_of_weighted.pdf';
exportgraphics(gcf, filename, ...
    'Append', false, ...
    'ContentType', 'vector');

