clear all;


%% plot fitting procedure
load('/media/harveylab/500GB/Yichen/Data/Stimuli/params_ILD_Linear.mat')
ILDs = params.dotOrder(9:90); % each ild is 1.5s
time = linspace(0,1.5*size(ILDs,1),size(ILDs,1));
x  =time;
y  =ILDs;

% stimulus matrix in lin space
fig = figure('Color','w'); hold on
plot(x, y, ...
    'LineStyle','none', ...   
    'Marker','o', ...         
    'MarkerSize',3, ...       
    'MarkerFaceColor','k', ...
    'MarkerEdgeColor','k');axis square
set(gca,'Box','on','TickDir','in','LineWidth',1.2)
xlabel('Time (s)')
ylabel('ILD value')
title('A single stimuli cycle')
set(fig,'PaperPositionMode','auto');
set(fig,'Renderer','painters');   % best for vector
filename = 'stimulus matrix lin.pdf';
exportgraphics(gcf, filename, ...
    'Append', false, ...
    'ContentType', 'vector');

tmpplot2 = calculateGaussian(sinh(mu), sinh(sigma), ILDs);
tmpplot2 = (tmpplot2 - min(tmpplot2)) / (max(tmpplot2) - min(tmpplot2));
% tmpplot2 = calculateGaussian(sinh(mu), sinh(sigma), asinh(ILDs));
fig = figure('Color','w'); hold on
plot(time, tmpplot2, ...
    'LineStyle','-', ...
    'Color','k',...
    'Marker','o', ...         
    'MarkerSize',3, ...       
    'MarkerFaceColor','k', ...
    'MarkerEdgeColor','k')
axis square
set(gca,'Box','on','TickDir','in','LineWidth',1.2)
xlabel('Time (s)')
ylabel('ILD value')
title('A single stimuli cycle')
set(fig,'PaperPositionMode','auto');
set(fig,'Renderer','painters');   % best for vector
filename = 'modelwithILD_lin.pdf';
exportgraphics(gcf, filename, ...
    'Append', false, ...
    'ContentType', 'vector');



tmpMore = calculateGaussian(sinh(mu), sinh(sigma), xvalsMore);
tmpMore = (tmpMore - min(tmpMore)) / (max(tmpMore) - min(tmpMore));
fig = figure('Color','w'); hold on
plot(xvalsMore, tmpMore, '-',  'LineWidth', 2); axis square
set(gca,'Box','on','TickDir','in','LineWidth',1.2)
set(fig,'PaperPositionMode','auto');
set(fig,'Renderer','painters');   % best for vector
filename = 'candidat_model_lin.pdf';
exportgraphics(gcf, filename, ...
    'Append', false, ...
    'ContentType', 'vector');
%% log
% stimulus matrix in log space
fig = figure('Color','w'); hold on
plot(x, asinh(y), ...
    'LineStyle','none', ...   
    'Marker','o', ...         
    'MarkerSize',3, ...       
    'MarkerFaceColor','k', ...
    'MarkerEdgeColor','k');axis square
set(gca,'Box','on','TickDir','in','LineWidth',1.2)
xlabel('Time (s)')
ylabel('ILD value')
yticks(asinh([-22 -16 -8 -4 -2 -1 0 1 2 4 8 16 22]))
yticklabels([-22 -16 -8 -4 -2 -1 0 1 2 4 8 16 22])
title('A single stimuli cycle')
set(fig,'PaperPositionMode','auto');
set(fig,'Renderer','painters');   % best for vector
filename = 'stimulus matrix log.pdf';
exportgraphics(gcf, filename, ...
    'Append', false, ...
    'ContentType', 'vector');


cd('/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1');
startup;
mrVista 3;
addpath '/media/harveylab/500GB/Yichen/Code'
opts = struct();
opts.markerSize = 5;
opts.predLineWidth=1.5;
opts.rawLineWidth=0.5;
load('cmap2.mat');
load('MLBPPrefminus038.mat')
Mstest = [ MLBPPrefminus038 ];  % struct array

% candidate model with ILD in log space
mu    = Mstest.rfParams(1);
sigma = Mstest.rfParams(3);
xvalsMore= -22:0.01:22;
tmpMore2 = calculateGaussian(mu, sigma, asinh(xvalsMore));


tmpplot = calculateGaussian(mu, sigma, asinh(ILDs));
tmpplot = (tmpplot - min(tmpplot)) / (max(tmpplot) - min(tmpplot));
% tmpplot2 = calculateGaussian(sinh(mu), sinh(sigma), asinh(ILDs));
fig = figure('Color','w'); hold on
plot(time, tmpplot, ...
    'LineStyle','-', ...
    'Color','k',...
    'Marker','o', ...         
    'MarkerSize',3, ...       
    'MarkerFaceColor','k', ...
    'MarkerEdgeColor','k')
axis square
set(gca,'Box','on','TickDir','in','LineWidth',1.2)
xlabel('Time (s)')
ylabel('ILD value')
title('A single stimuli cycle')
set(fig,'PaperPositionMode','auto');
set(fig,'Renderer','painters');   % best for vector
filename = 'modelwithILD_log.pdf';
exportgraphics(gcf, filename, ...
    'Append', false, ...
    'ContentType', 'vector');


tmpMore2 = (tmpMore2 - min(tmpMore2)) / (max(tmpMore2) - min(tmpMore2));
fig = figure('Color','w'); hold on
plot(asinh(xvalsMore), tmpMore2, '-',  'LineWidth', 2); axis square
set(gca,'Box','on','TickDir','in','LineWidth',1.2)
set(fig,'PaperPositionMode','auto');
set(fig,'Renderer','painters');   % best for vector
filename = 'candidat_model_log.pdf';
exportgraphics(gcf, filename, ...
    'Append', false, ...
    'ContentType', 'vector');

% candidatemodelwithild = tmpplot;
% predicted_resp = Mstest.currTsData.pred;


% this does not work
x = candidatemodelwithild(:);
y = predicted_resp(:);
eps_val = 1e-6;
X = fft(x);
Y = fft(y);
H = Y ./ (X + eps_val);
hrf = real(ifft(H));
figure; plot(time, hrf, '--',  'LineWidth', 2); axis square
hrf = hrf(1:25);
% another way
lambda = 0.01;  
H = (conj(X) .* Y) ./ (conj(X).*X + lambda);
hrf = real(ifft(H));



%%

% from Ben for color scale
colorscale1=.65;
colorscale2=.4;
% Make it 40% or 65% colored, the rest white

% 'Color', [1 1 1]-([1 1 1]-colorTrip)*colorscale2,'LineWidth',1

%% bank of monotonic
% X-axis for the compressive monotonic function
xLinMono = 56:0.5:78;     % you can adjust range as needed
xLinMono = (xLinMono - min(xLinMono)) ./ ...
        (max(xLinMono) - min(xLinMono));% Range of compression exponents
cvals = 0:0.1:1;          % 11 monotonic functions
nC = length(cvals);
cvals = 0:0.1:1;          % 11 monotonic functions
% Colour map
colours = parula(length(cvals));
% Pre-allocate
compressiveBank = zeros(length(cvals), length(xLinMono));
% Compute compressive monotonic functions
for i = 1:length(cvals)
    c = cvals(i);
    compressiveBank(i,:) = xLinMono .^ c;      % x^c, monotonic, compressive when c<1
    compressiveBank(i,:) = compressiveBank(i,:) ./ max(compressiveBank(i,:)); % normalize
end

blue = [0 0.2 0.8];
red  = [0.8 0 0];
nMap = 256;  % 连续色图分辨率

cmapCont = [ ...
    linspace(blue(1), red(1), nMap)', ...
    linspace(blue(2), red(2), nMap)', ...
    linspace(blue(3), red(3), nMap)'  ...
];
cmap = [ ...
    linspace(blue(1), red(1), nC)', ...
    linspace(blue(2), red(2), nC)', ...
    linspace(blue(3), red(3), nC)'  ...
];
fig = figure('Color','w');   % figure 
ax = gca;
ax.Color = 'w';        %
hold on;

for i = 1:nC
    plot(xLinMono, compressiveBank(i,:), ...
        'Color', cmap(i,:), ...
        'LineWidth', 2);
end

xlabel('x (linear)');
ylabel('Response amplitude');
title('Bank of Compressive Monotonic Functions');

% colormap(cmap);
% cb = colorbar;
% cb.Ticks = linspace(0,1,nC);
% cb.TickLabels = string(cvals);
% title(cb, 'c value');

colormap(cmapCont);
caxis([min(cvals) max(cvals)]);

cb = colorbar;
cb.Ticks = cvals;
cb.TickLabels = string(cvals);
title(cb, 'c value');

axis square
set(gca,'Box','off','TickDir','in','LineWidth',1.2)
set(fig,'PaperPositionMode','auto');
set(fig,'Renderer','painters');   % best for vector
filename = 'bank_of_monotonic.pdf';
exportgraphics(gcf, filename, ...
    'Append', false, ...
    'ContentType', 'vector');



%% bank of balance
% X-axis for the compressive monotonic function
xLinMono = 56:0.5:78;     % you can adjust range as needed
xLinMono = (xLinMono - min(xLinMono)) ./ ...
        (max(xLinMono) - min(xLinMono));% Range of compression exponents
dB_left  = fliplr(xLinMono);   % left channel
dB_right = xLinMono;           % right channel

cvals = 0:0.1:1;          % 11 monotonic functions
weight = 0.7;

responses = zeros(length(cvals), length(dB_left));
for i = 1:length(cvals)
    expLeft  = cvals(i);
    expRight = cvals(i);   

    responses(i,:) = ...
        (dB_left  .^ expLeft) + ...
        weight * (dB_right .^ expRight);

    % normalize for visualization
    responses(i,:) = responses(i,:) ./ max(responses(i,:));
end

figure; hold on;
colours = parula(length(cvals));

for i = 1:length(cvals)
    plot(xLinMono, responses(i,:), ...
        'Color', colours(i,:), 'LineWidth', 2);
end

xlabel('Normalized stimulus axis');
ylabel('Normalized response');
title('Compressive Weighted Monotonic Model');

cb = colorbar;
cb.Ticks = linspace(0,1,length(cvals));
cb.TickLabels = string(cvals);
title(cb, 'Compression exponent');
box on;

%% bank of weighted
% details of variations in script "/media/harveylab/500GB/Yichen/Code/made_by_Yichen/bank_of_weighted"

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




%% bank of ILDlog

% prefLog=0:0.5:7;
% prefLin=2.^prefLog;
% sigmaLog=0.5;
% prefLog=asinh(-25:1:25);
clear Gaussians;
prefLog=-4:1:4;
sigmaLog=0.5;
% sigmaLog=[0.05 0.1 0.2];
% xLog=-asinh(25):0.01:(max(prefLog)+4*sigmaLog);
xLog=-4:0.01:(max(prefLog)+4*sigmaLog);
% colours=hsv(length(prefLog));
nC = length(prefLog);
blue = [0 0.2 0.8];
red  = [0.8 0 0];
colours = [ ...
    linspace(blue(1), red(1), nC)', ...
    linspace(blue(2), red(2), nC)', ...
    linspace(blue(3), red(3), nC)'  ...
];
nMap = 256;  %

cmapCont = [ ...
    linspace(blue(1), red(1), nMap)', ...
    linspace(blue(2), red(2), nMap)', ...
    linspace(blue(3), red(3), nMap)'  ...
];
for whichGaus=1:length(prefLog)
    Gaussians(whichGaus,:)=calculateGaussian(prefLog(whichGaus), sigmaLog, xLog);
    Gaussians(whichGaus,:)=Gaussians(whichGaus,:)./max(Gaussians(whichGaus,:));
end

%Log tuning functions
LogFigure = figure('Color','w');   % figure 
ax = gca;
ax.Color = 'w';        %
hold on;

for whichGaus=1:length(prefLog)
    s=prefLog(whichGaus);
    plot(xLog, Gaussians(whichGaus,:), 'color', colours(whichGaus, :), 'LineWidth', 2, ...
        'DisplayName', ['ILD=' num2str(s)]);
end
xlabel('ILD preference (log scale)');
ylabel('Response amplitude')
xticks(floor(min(prefLog)):floor(max(xLog)));
xticklabels((floor(min(prefLog)):floor(max(xLog))));
axis([-4 4 0 1])
ax=gca;
ax.FontName='helvetica'
ax.Units='points';
ax.LineWidth=1;
ax.TickLength = [0.012 0.012];
ax.FontSize=16;
lgd = legend('Location','eastoutside');
lgd.FontSize = 10;

% colormap(cmapCont);
% caxis([min(prefLog) max(prefLog)]);

% cb = colorbar;
% cb.Ticks = [asinh([-22 -16 -8 -4 -2 -1 0 1 2 4 8 16 22])];
% cb.TickLabels = string([-22 -16 -8 -4 -2 -1 0 1 2 4 8 16 22]);
% title(cb, 'Preferred ILD');

set(gca,'Box','off','TickDir','in','LineWidth',1.2)
xlabel('ILD')
ylabel('Normalized neural response amplitude')
xticks(asinh([-22 -16 -8 -4 -2 -1 0 1 2 4 8 16 22]))
xticklabels([-22 -16 -8 -4 -2 -1 0 1 2 4 8 16 22])
title('A single stimuli cycle')
set(LogFigure,'PaperPositionMode','auto');
set(LogFigure,'Renderer','painters');   % best for vector
filename = 'bank_of_log_Gaussian_in_log.pdf';
exportgraphics(gcf, filename, ...
    'Append', false, ...
    'ContentType', 'vector');


%% %% bank of ILDlog _ allow sd changes
clear Gaussians;
pref = 3;
sigmas = [0.2 0.4 0.8 1 2 3];
xLog = -4:0.01:4;

nC = length(sigmas);
blue = [0 0.2 0.8];
red  = [0.8 0 0];
colours = [ ...
    linspace(blue(1), red(1), nC)', ...
    linspace(blue(2), red(2), nC)', ...
    linspace(blue(3), red(3), nC)'  ...
];
nMap = 256;  

cmapCont = [ ...
    linspace(blue(1), red(1), nMap)', ...
    linspace(blue(2), red(2), nMap)', ...
    linspace(blue(3), red(3), nMap)'  ...
];


fig = figure('Color','w');   % figure 
ax = gca;
ax.Color = 'w';        %
hold on;
for sidx = 1:length(sigmas)
    s=sigmas(sidx);
    g = calculateGaussian(pref, s, xLog);
    g = g ./ max(g);
    plot(xLog, g, 'color', colours(sidx, :), 'LineWidth', 2, ...
        'DisplayName', ['\sigma = ' num2str(s)]);
end
xlabel('ILD (log scale)');
ylabel('Normalized response');
title('Effect of tuning width (\sigma)');
legend('Location','northwest');
axis([-4 4 0 1]);


% colormap(cmapCont);
% caxis([min(sigmas) max(sigmas)]);

% cb = colorbar;
% cb.Ticks = sigmas;
% cb.TickLabels = string(sigmas);
% title(cb, 'Width');

set(gca,'Box','off','TickDir','in','LineWidth',1.2)
xlabel('ILD')
ylabel('Normalized neural response amplitude')
xticks(asinh([-22 -16 -8 -4 -2 -1 0 1 2 4 8 16 22]))
xticklabels([-22 -16 -8 -4 -2 -1 0 1 2 4 8 16 22])
title('A single stimuli cycle')
set(LogFigure,'PaperPositionMode','auto');
set(LogFigure,'Renderer','painters');   % best for vector
filename = 'bank_of_log_Gaussian_in_log_sigma.pdf';
exportgraphics(gcf, filename, ...
    'Append', false, ...
    'ContentType', 'vector');

%% Bank of log-Gaussians shown in linear ILD space

% Parameters defined in log/asinh space
prefLog  = -4:1:4;
sigmaLog = 0.5;

% Linear ILD axis for plotting
xLin = linspace(sinh(-4), sinh(4), 1000);

% Convert linear axis into log/asinh space for evaluation
xAsinh = asinh(xLin);

% Colours
nC = length(prefLog);
blue = [0 0.2 0.8];
red  = [0.8 0 0];
colours = [ ...
    linspace(blue(1), red(1), nC)', ...
    linspace(blue(2), red(2), nC)', ...
    linspace(blue(3), red(3), nC)'  ...
];

nMap = 256;
cmapCont = [ ...
    linspace(blue(1), red(1), nMap)', ...
    linspace(blue(2), red(2), nMap)', ...
    linspace(blue(3), red(3), nMap)'  ...
];

% Preallocate
Gaussians = zeros(length(prefLog), length(xLin));

% Evaluate each log-Gaussian on the transformed axis
for whichGaus = 1:length(prefLog)
    g = calculateGaussian(prefLog(whichGaus), sigmaLog, xAsinh);
    Gaussians(whichGaus,:) = g ./ max(g);
end

% Plot in linear ILD space
fig = figure('Color','w');
ax = gca;
ax.Color = 'w';
hold on;

for whichGaus = 1:length(prefLog)
    s=prefLog(whichGaus);
    plot(xLin, Gaussians(whichGaus,:), ...
        'Color', colours(whichGaus,:), ...
        'LineWidth', 2, ...
        'DisplayName', ['ILD=' num2str(s)]);
end

xlabel('ILD preference (linear scale)');
ylabel('Normalized response amplitude');
title('Log-Gaussian tuning functions shown in linear ILD space');
lgd = legend('Location','eastoutside');
lgd.FontSize = 10;
% ax.FontName = 'helvetica';
% ax.Units = 'points';
% ax.LineWidth = 1;
% ax.TickLength = [0.012 0.012];
% ax.FontSize = 16;
% set(gca,'Box','off','TickDir','in','LineWidth',1.2);

% xlim([sinh(-4) sinh(4)]);
xlim([-22 22]);
ylim([0 1]);


set(gca,'Box','off','TickDir','in','LineWidth',1.2)
xlabel('ILD')
ylabel('Normalized neural response amplitude')
xticks([-22 -16 -12 -8 -4  0 4 8 12 16 22])
xticklabels([-22 -16 -12 -8 -4  0  4 8 12 16 22])
% title('A single stimuli cycle')
set(fig,'PaperPositionMode','auto');
set(fig,'Renderer','painters');   % best for vector
filename = 'bank_of_log_Gaussian_in_lin_mean.pdf';
exportgraphics(gcf, filename, ...
    'Append', false, ...
    'ContentType', 'vector');

%% Bank of log-Gaussians shown in linear ILD space, with fixed preferred ILD and varied sigma
% Fixed preferred ILD in log/asinh space
prefLog = 3;
% Sigma values in log/asinh space
sigmasLog = [0.2 0.4 0.8 1 2 3];
% Linear ILD axis for plotting
xLin = linspace(sinh(-4), sinh(4), 1000);
% Convert linear axis to log/asinh space for evaluating the Gaussian
xAsinh = asinh(xLin);

% Colour gradient
nC = length(sigmasLog);
blue = [0 0.2 0.8];
red  = [0.8 0 0];
colours = [ ...
    linspace(blue(1), red(1), nC)', ...
    linspace(blue(2), red(2), nC)', ...
    linspace(blue(3), red(3), nC)'  ...
];

% Preallocate
Gaussians = zeros(nC, length(xLin));

% Compute curves
for sidx = 1:nC
    s = sigmasLog(sidx);
    g = calculateGaussian(prefLog, s, xAsinh);
    Gaussians(sidx,:) = g ./ max(g);
end

% Plot
fig = figure('Color','w');
hold on;

for sidx = 1:nC
    s = sigmasLog(sidx);

    % Optional: corresponding FWHM in linear space at this prefLog
    fwhmLog = 2 * sqrt(2 * log(2)) * s;
    fwhmLin = sinh(prefLog + fwhmLog/2) - sinh(prefLog - fwhmLog/2);

    plot(xLin, Gaussians(sidx,:), ...
        'Color', colours(sidx,:), ...
        'LineWidth', 2, ...
        'DisplayName', sprintf('FWHM=%.1f', fwhmLin));
end


% Axis formatting
xlim([-22 22]);
ylim([0 1]);

set(gca, 'Box', 'off', ...
         'TickDir', 'in', ...
         'LineWidth', 1.2, ...
         'FontSize', 14, ...
         'FontName', 'Helvetica');

xlabel('ILD');
ylabel('Normalized neural response amplitude');
title('Log-Gaussian tuning functions in linear ILD space');

xticks([-22 -16 -12 -8 -4  0 4 8 12 16 22]);
xticklabels([-22 -16 -12 -8 -4  0 4 8 12 16 22]);

legend('Location', 'northwest');

% Export
set(fig, 'PaperPositionMode', 'auto');
set(fig, 'Renderer', 'painters');

filename = 'bank_of_log_Gaussian_in_lin_sigma.pdf';
exportgraphics(fig, filename, ...
    'Append', false, ...
    'ContentType', 'vector');


%% Bank of linear-Gaussians in linear ILD space: fixed sigma, varying preferred ILD


% Parameters defined directly in linear ILD space
prefLin  = [-22 -16 -12 -8 -4 0 4 8 12 16 22];
sigmaLin = 4;   % fixed sigma in linear ILD units

% Linear ILD axis for plotting
xLin = linspace(-22, 22, 1000);

% Colours
nC = length(prefLin);
blue = [0 0.2 0.8];
red  = [0.8 0 0];
colours = [ ...
    linspace(blue(1), red(1), nC)', ...
    linspace(blue(2), red(2), nC)', ...
    linspace(blue(3), red(3), nC)'  ...
];

% Preallocate
Gaussians = zeros(length(prefLin), length(xLin));

% Compute linear-space Gaussians
for whichGaus = 1:length(prefLin)
    g = calculateGaussian(prefLin(whichGaus), sigmaLin, xLin);
    Gaussians(whichGaus,:) = g ./ max(g);
end

% Plot
fig = figure('Color','w');
hold on;

for whichGaus = 1:length(prefLin)
    s = prefLin(whichGaus);
    plot(xLin, Gaussians(whichGaus,:), ...
        'Color', colours(whichGaus,:), ...
        'LineWidth', 2, ...
        'DisplayName', ['ILD=' num2str(s)]);
end

xlim([-22 22]);
ylim([0 1]);
lgd = legend('Location','eastoutside');
lgd.FontSize = 10;

set(gca, 'Box', 'off', ...
         'TickDir', 'in', ...
         'LineWidth', 1.2, ...
         'FontSize', 14, ...
         'FontName', 'Helvetica');

xlabel('ILD');
ylabel('Normalized neural response amplitude');
title(sprintf('Linear-Gaussian tuning functions in linear ILD space (\\sigma = %.1f)', sigmaLin));

xticks([-22 -16 -12 -8 -4 0 4 8 12 16 22]);
xticklabels([-22 -16 -12 -8 -4 0 4 8 12 16 22]);

set(fig, 'PaperPositionMode', 'auto');
set(fig, 'Renderer', 'painters');

filename = 'bank_of_linear_Gaussian_in_lin_mean.pdf';
exportgraphics(fig, filename, ...
    'Append', false, ...
    'ContentType', 'vector');

%% Bank of linear-Gaussians in linear ILD space: fixed preferred ILD, varying sigma

% Fixed preferred ILD in linear space
prefLin = 10;

% Sigma values directly in linear ILD units
sigmasLin = [1 2 4 6 8 10];

% Linear ILD axis
xLin = linspace(-22, 22, 1000);

% Colours
nC = length(sigmasLin);
blue = [0 0.2 0.8];
red  = [0.8 0 0];
colours = [ ...
    linspace(blue(1), red(1), nC)', ...
    linspace(blue(2), red(2), nC)', ...
    linspace(blue(3), red(3), nC)'  ...
];

% Preallocate
Gaussians = zeros(nC, length(xLin));

% Compute
for sidx = 1:nC
    s = sigmasLin(sidx);
    g = calculateGaussian(prefLin, s, xLin);
    Gaussians(sidx,:) = g ./ max(g);
end

% Plot
fig = figure('Color','w');
hold on;

for sidx = 1:nC
    s = sigmasLin(sidx);
    fwhmLin = 2 * sqrt(2 * log(2)) * s;

    plot(xLin, Gaussians(sidx,:), ...
        'Color', colours(sidx,:), ...
        'LineWidth', 2, ...
        'DisplayName', ['\sigma = ' num2str(s)]);
end
xlim([-22 22]);
ylim([0 1]);

set(gca, 'Box', 'off', ...
         'TickDir', 'in', ...
         'LineWidth', 1.2, ...
         'FontSize', 14, ...
         'FontName', 'Helvetica');

xlabel('ILD');
ylabel('Normalized neural response amplitude');
title('Linear-Gaussian tuning functions in linear ILD space');

xticks([-22 -16 -12 -8 -4 0 4 8 12 16 22]);
xticklabels([-22 -16 -12 -8 -4 0 4 8 12 16 22]);

legend('Location', 'northwest');

set(fig, 'PaperPositionMode', 'auto');
set(fig, 'Renderer', 'painters');

filename = 'bank_of_linear_Gaussian_in_lin_sigma.pdf';
exportgraphics(fig, filename, ...
    'Append', false, ...
    'ContentType', 'vector');

%% bank of ILDlin_in lin space
% prefLog=0:0.5:7;
% prefLin=2.^prefLog;
% sigmaLog=0.5;
% prefLog=asinh(-25:1:25);
clear Gaussians;
prefLog=-4:1:4;
sigmaLog=0.5;
% sigmaLog=[0.05 0.1 0.2];
% xLog=-asinh(25):0.01:(max(prefLog)+4*sigmaLog);
xLog=-4:0.01:(max(prefLog)+4*sigmaLog);
% colours=hsv(length(prefLog));
nC = length(prefLog);
blue = [0 0.2 0.8];
red  = [0.8 0 0];
colours = [ ...
    linspace(blue(1), red(1), nC)', ...
    linspace(blue(2), red(2), nC)', ...
    linspace(blue(3), red(3), nC)'  ...
];
nMap = 256;  %

cmapCont = [ ...
    linspace(blue(1), red(1), nMap)', ...
    linspace(blue(2), red(2), nMap)', ...
    linspace(blue(3), red(3), nMap)'  ...
];
for whichGaus=1:length(prefLog)
    Gaussians(whichGaus,:)=calculateGaussian(prefLog(whichGaus), sigmaLog, xLog);
    Gaussians(whichGaus,:)=Gaussians(whichGaus,:)./max(Gaussians(whichGaus,:));
end

%Log tuning functions
figure('Color','w');   % figure 
ax = gca;
ax.Color = 'w';        %
hold on;

for whichGaus=1:length(prefLog)
    plot(xLog, Gaussians(whichGaus,:), 'color', colours(whichGaus, :), 'LineWidth', 2);
end
xlabel('ILD preference (log scale)');
ylabel('Response amplitude')
xticks(floor(min(prefLog)):floor(max(xLog)));
xticklabels((floor(min(prefLog)):floor(max(xLog))));
axis([-4 4 0 1])
ax=gca;
ax.FontName='helvetica'
ax.Units='points';
ax.LineWidth=1;
ax.TickLength = [0.012 0.012];
ax.FontSize=16;

colormap(cmapCont);
caxis([min(prefLog) max(prefLog)]);

cb = colorbar;
cb.Ticks = [asinh([-22 -16 -8 -4 -2 -1 0 1 2 4 8 16 22])];
cb.TickLabels = string([-22 -16 -8 -4 -2 -1 0 1 2 4 8 16 22]);
title(cb, 'Preferred ILD');

set(gca,'Box','off','TickDir','in','LineWidth',1.2)
xlabel('ILD')
ylabel('Normalized neural response amplitude')
xticks(asinh([-22 -16 -8 -4 -2 -1 0 1 2 4 8 16 22]))
xticklabels([-22 -16 -8 -4 -2 -1 0 1 2 4 8 16 22])
title('A single stimuli cycle')
set(LogFigure,'PaperPositionMode','auto');
set(LogFigure,'Renderer','painters');   % best for vector
filename = 'bank_of_log_Gaussian_in_log.pdf';
exportgraphics(gcf, filename, ...
    'Append', false, ...
    'ContentType', 'vector');


%% %% bank of ILD lin in lin space _ allow sd changes
clear Gaussians;
pref = 3;
sigmas = [0.2 0.4 0.8 1 2 3];
xLog = -4:0.01:4;

nC = length(sigmas);
blue = [0 0.2 0.8];
red  = [0.8 0 0];
colours = [ ...
    linspace(blue(1), red(1), nC)', ...
    linspace(blue(2), red(2), nC)', ...
    linspace(blue(3), red(3), nC)'  ...
];
nMap = 256;  

cmapCont = [ ...
    linspace(blue(1), red(1), nMap)', ...
    linspace(blue(2), red(2), nMap)', ...
    linspace(blue(3), red(3), nMap)'  ...
];


fig = figure('Color','w');   % figure 
ax = gca;
ax.Color = 'w';        %
hold on;
for sidx = 1:length(sigmas)
    s=sigmas(sidx);
    g = calculateGaussian(pref, s, xLog);
    g = g ./ max(g);
    plot(xLog, g, 'color', colours(sidx, :), 'LineWidth', 2, ...
        'DisplayName', ['\sigma = ' num2str(s)]);
end
xlabel('ILD (log scale)');
ylabel('Normalized response');
title('Effect of tuning width (\sigma)');
legend('Location','northwest');
axis([-4 4 0 1]);

colormap(cmapCont);
caxis([min(sigmas) max(sigmas)]);

% cb = colorbar;
% cb.Ticks = sigmas;
% cb.TickLabels = string(sigmas);
% title(cb, 'Width');

set(gca,'Box','off','TickDir','in','LineWidth',1.2)
xlabel('ILD')
ylabel('Normalized neural response amplitude')
xticks(asinh([-22 -16 -8 -4 -2 -1 0 1 2 4 8 16 22]))
xticklabels([-22 -16 -8 -4 -2 -1 0 1 2 4 8 16 22])
title('A single stimuli cycle')
set(LogFigure,'PaperPositionMode','auto');
set(LogFigure,'Renderer','painters');   % best for vector
filename = 'bank_of_log_Gaussian_in_log_sigma.pdf';
exportgraphics(gcf, filename, ...
    'Append', false, ...
    'ContentType', 'vector');

%%%%%%%%%%%
%% old not used 

%%%%%%%%%%%
%% bank of ILDlog2 _ to lin space - wrong version

% clear Gaussians;
% sigmaLog=0.5;
% prefLog=-4:1:4;
% for i = 1:length(prefLog)
%     fwhms(i)=sigmaLog.*(2*sqrt(2*log(2)));            
%     fwhms(i)=sinh(prefLog(i)+fwhms(i)./2)-sinh(prefLog(i)-fwhms(i)./2); 
%     sigma(i)=fwhms(i);
% end
% prefLog=linspace(sinh(-4),sinh(4),length(sigma));
% sigmaLog = sigma;
% xLog=prefLog;
% nC = length(prefLog);
% blue = [0 0.2 0.8];
% red  = [0.8 0 0];
% colours = [ ...
%     linspace(blue(1), red(1), nC)', ...
%     linspace(blue(2), red(2), nC)', ...
%     linspace(blue(3), red(3), nC)'  ...
% ];
% nMap = 256;  %
% 
% cmapCont = [ ...
%     linspace(blue(1), red(1), nMap)', ...
%     linspace(blue(2), red(2), nMap)', ...
%     linspace(blue(3), red(3), nMap)'  ...
% ];
% for whichGaus=1:length(prefLog)
%     Gaussians(whichGaus,:)=calculateGaussian(prefLog(whichGaus), sigmaLog(whichGaus), linspace(min(xLog),max(xLog),1000));
%     Gaussians(whichGaus,:)=Gaussians(whichGaus,:)./max(Gaussians(whichGaus,:));
% end
% 
% %Log tuning functions
% figure('Color','w');   % figure 
% ax = gca;
% ax.Color = 'w';        %
% hold on;
% 
% for whichGaus=1:length(prefLog)
%     plot(linspace(min(xLog),max(xLog),1000), Gaussians(whichGaus,:), 'color', colours(whichGaus, :), 'LineWidth', 2);
% end
% xlabel('ILD preference (lin scale)');
% ylabel('Response amplitude')
% 
% colormap(cmapCont);
% caxis([min(prefLog) max(prefLog)]);
% 
% cb = colorbar;
% cb.Ticks = prefLog;
% cb.TickLabels = string(prefLog);
% title(cb, 'Preferred ILD');
%% %% bank of ILDlog2 _ allow sd changes _ to lin space - wrong version
% clear Gaussians;
% pref = 3;
% sigmas = [0.2 0.4 0.8 1 2 3];
% for i = 1:length(sigmas)
%     fwhms(i)=sigmas(i).*(2*sqrt(2*log(2)));            
%     fwhms(i)=sinh(pref+fwhms(i)./2)-sinh(pref-fwhms(i)./2); 
%     sigma_lin(i)=fwhms(i);
% end
% prefLog=sinh(3);
% sigmas = sigma_lin;
% 
% xLog = sinh(-4.1):3:sinh(4.1);
% 
% nC = length(sigmas);
% blue = [0 0.2 0.8];
% red  = [0.8 0 0];
% colours = [ ...
%     linspace(blue(1), red(1), nC)', ...
%     linspace(blue(2), red(2), nC)', ...
%     linspace(blue(3), red(3), nC)'  ...
% ];
% nMap = 256;  %
% 
% cmapCont = [ ...
%     linspace(blue(1), red(1), nMap)', ...
%     linspace(blue(2), red(2), nMap)', ...
%     linspace(blue(3), red(3), nMap)'  ...
% ];
% 
% 
% figure('Color','w');   % figure 
% ax = gca;
% ax.Color = 'w';        %
% hold on;
% for sidx = 1:length(sigmas)
%     s=sigmas(sidx);
%     g = calculateGaussian(pref, s, xLog);
%     g = g ./ max(g);
%     plot(xLog, g, 'color', colours(sidx, :), 'LineWidth', 2, ...
%         'DisplayName', ['\sigma = ' num2str(s)]);
% end
% xlabel('ILD (log scale)');
% ylabel('Normalized response');
% title('Effect of tuning width (\sigma)');
% legend;
%% bank of log mirrored gaussian
clear Gaussians;
prefLin=-4:1:4;
sigma=0.8;
x = -4:0.01:(max(prefLin)+4*sigma);

weights = [0.2 0.5 0.8]; 
weights2 = 1-weights;
gauss = @(mu, sigma, x) exp(-0.5 * ((x - mu) ./ sigma).^2);

prefs = [1 2 3];    
nP = length(prefs);
nW = length(weights);

figure('Color','w');   % figure 
ax = gca;
ax.Color = 'w'; 
hold on;
for i = 1:nP
    pref = prefs(i);
    prefL = -pref;
    prefR =  pref;

    for j = 1:nW
        w = weights(j);
        w2 = weights2(j);

        GL = w2*gauss(prefL, sigma, x);
        GR = w *gauss(prefR, sigma, x);

        R = GL +  GR;
        R = (R - min(R)) ./ (max(R) - min(R));

        subplot(nP, nW, (i-1)*nW + j);
        plot(x, R, 'b', 'LineWidth', 2);
        hold on;
        plot(x, GL , '--', 'LineWidth', 1);
        plot(x, GR , '--', 'LineWidth', 1);
        box off;

        axis([-4.1 4.1 0 1]);
        if i == 1
            title(['w = ' num2str(w)]);
        end
        if j == 1
            ylabel(['pref = \pm' num2str(pref)]);
        end
    end
end

% sgtitle('Mirrored Gaussian model (left + weighted right)');
% 
% pref = 12;
% prefL = -pref;
% prefR = pref;
% 
% figure; hold on;
% colours = parula(length(weights));
% 
% for j = 1:length(weights)
%     w = weights(j);
%     R = gauss(prefL, sigma, x) + w * gauss(prefR, sigma, x);
%     R = R ./ max(R);
%     plot(x, R, 'LineWidth', 2, 'Color', colours(j,:), ...
%         'DisplayName', ['w=' num2str(w)]);
% end
% 
% xlabel('ILD (linear)');
% ylabel('Normalized response');
% title(['Mirrored Gaussian (pref = \pm' num2str(pref) ')']);
% legend;
% axis([-25 25 0 1]);


%% %% bank of log Mirror _ allow sd changes
% fix pref and weight, change width

%  fix pref, change weight and width
pref = 2;
prefL = -pref;
prefR =  pref;

sigmas  = [0.5 1 2];
weights = [0.2 0.5 0.8];
weights2 = 1-weights;
x = -4:0.01:(4+4*0.8);

figure('Color','w');   % figure 
ax = gca;
ax.Color = 'w'; 
hold on;
for i = 1:length(sigmas)
    for j = 1:length(weights)
        s = sigmas(i);
        w = weights(j);
        w2 = weights2(j);

        GL = w *gauss(prefL, s, x);
        GR = w2  * gauss(prefR, s, x);
        R  = GL + GR;
        R = (R - min(R)) ./ (max(R) - min(R));

        subplot(length(sigmas), length(weights), ...
                (i-1)*length(weights) + j);
        plot(x, R, 'b', 'LineWidth', 2);
        hold on;
        plot(x, GL , '--', 'LineWidth', 1);
        plot(x, GR , '--', 'LineWidth', 1);
        box off;
        axis([-4.1 4.1 0 1]);

        if i == 1
            title(['w=' num2str(w)]);
        end
        if j == 1
            ylabel(['\sigma=' num2str(s)]);
        end
    end
end

sgtitle('Mirrored Gaussian: effect of tuning width and weight');







%% bank of ILIDlinear
% prefLog=0:0.5:7;
% prefLin=2.^prefLog;
% sigmaLog=0.5;
% prefLog=asinh(-25:1:25);
prefLin=-25:4:25;
sigmaLog=8;
% sigmaLog=[0.05 0.1 0.2];
% xLog=-asinh(25):0.01:(max(prefLog)+4*sigmaLog);
xLog=-25:1:(max(prefLin)+4*sigmaLog);
colours=hsv(length(prefLin));
for whichGaus=1:length(prefLin)
    GaussiansLin(whichGaus,:)=calculateGaussian(prefLin(whichGaus), sigmaLog, xLog);
    GaussiansLin(whichGaus,:)=GaussiansLin(whichGaus,:)./max(GaussiansLin(whichGaus,:));
end

%Log tuning functions
LogFigure=figure; hold on;
for whichGaus=1:length(prefLin)
    plot(xLog, GaussiansLin(whichGaus,:), 'color', colours(whichGaus, :), 'LineWidth', 2);
end
xlabel('ILD preference (lin scale)');
ylabel('Response amplitude')
xticks(floor(min(prefLin)):4:floor(max(xLog)));
xticklabels((floor(min(prefLin)):4:floor(max(xLog))));
axis([-22 22 0 1])
ax=gca;
ax.FontName='helvetica'
ax.Units='points';
ax.LineWidth=1;
ax.TickLength = [0.012 0.012];
ax.FontSize=16;

%% %% bank of ILDlin2 _ allow sd changes
pref = 10;
sigmas = [5 10 15 20 25 30];
xLog = -25:1:25;

figure; hold on;
for s = sigmas
    g = calculateGaussian(pref, s, xLog);
    g = g ./ max(g);
    plot(xLog, g, 'LineWidth', 2, ...
        'DisplayName', ['\sigma = ' num2str(s)]);
end

xlabel('ILD (lin scale)');
ylabel('Normalized response');
title('Effect of tuning width (\sigma)');
legend;
axis([-25 25 0 1]);
box on;


%% bank of ILIDMirror -- fixed widtd, allow weight change
prefLin = -25:4:25;
sigma = 8;
x = -25:1:(max(prefLin)+4*sigma);

weights = [0.2 0.5 0.8]; 
weights2 = 1-weights;
gauss = @(mu, sigma, x) exp(-0.5 * ((x - mu) ./ sigma).^2);

prefs = [4 12 20];    
nP = length(prefs);
nW = length(weights);

figure;
for i = 1:nP
    pref = prefs(i);
    prefL = -pref;
    prefR =  pref;

    for j = 1:nW
        w = weights(j);
        w2 = weights2(j);

        GL = w2*gauss(prefL, sigma, x);
        GR = w *gauss(prefR, sigma, x);

        R = GL +  GR;
        R = R ;   % normalize for visualization

        subplot(nP, nW, (i-1)*nW + j);
        plot(x, R, 'k', 'LineWidth', 2);
        hold on;
        plot(x, GL , '--', 'LineWidth', 1);
        plot(x, GR , '--', 'LineWidth', 1);

        axis([-25 25 0 1]);
        if i == 1
            title(['w = ' num2str(w)]);
        end
        if j == 1
            ylabel(['pref = \pm' num2str(pref)]);
        end
    end
end

sgtitle('Mirrored Gaussian model (left + weighted right)');

pref = 12;
prefL = -pref;
prefR = pref;

figure; hold on;
colours = parula(length(weights));

for j = 1:length(weights)
    w = weights(j);
    R = gauss(prefL, sigma, x) + w * gauss(prefR, sigma, x);
    R = R ./ max(R);
    plot(x, R, 'LineWidth', 2, 'Color', colours(j,:), ...
        'DisplayName', ['w=' num2str(w)]);
end

xlabel('ILD (linear)');
ylabel('Normalized response');
title(['Mirrored Gaussian (pref = \pm' num2str(pref) ')']);
legend;
axis([-25 25 0 1]);

%% %% bank of ILDMirror _ allow sd changes
% fix pref and weight, change width
pref = 12;
prefL = -pref;
prefR =  pref;
weight = 0.6;

sigmas = [4 8 16];    % 举几个清晰的 SD
x = -25:0.5:25;

gauss = @(mu, s, x) exp(-0.5*((x-mu)./s).^2);

figure; hold on;
colours = parula(length(sigmas));

for i = 1:length(sigmas)
    s = sigmas(i);

    GL = gauss(prefL, s, x);
    GR = weight * gauss(prefR, s, x);

    R = GL + GR;
    R = R ./ max(R);

    plot(x, R, 'LineWidth', 2, ...
        'Color', colours(i,:), ...
        'DisplayName', ['\sigma = ' num2str(s)]);
end

xlabel('ILD');
ylabel('Normalized response');
title(['Mirrored Gaussian, pref=\pm' num2str(pref) ', w=' num2str(weight)]);
legend;
axis([-25 25 0 1]);

%  fix pref, change weight and width
pref = 12;
prefL = -pref;
prefR =  pref;

sigmas  = [4 8 16];
weights = [0.2 0.5 0.8];
weights2 = 1-weights;
x = -25:0.5:25;

figure;
for i = 1:length(sigmas)
    for j = 1:length(weights)
        s = sigmas(i);
        w = weights(j);
        w2 = weights2(j);

        GL = w *gauss(prefL, s, x);
        GR = w2  * gauss(prefR, s, x);
        R  = GL + GR;
        R  = R ;

        subplot(length(sigmas), length(weights), ...
                (i-1)*length(weights) + j);
        plot(x, R, 'k', 'LineWidth', 2);
        hold on;
        plot(x, GL , '--', 'LineWidth', 1);
        plot(x, GR , '--', 'LineWidth', 1);
        axis([-25 25 0 1]);

        if i == 1
            title(['w=' num2str(w)]);
        end
        if j == 1
            ylabel(['\sigma=' num2str(s)]);
        end
    end
end

sgtitle('Mirrored Gaussian: effect of tuning width and weight');



%% unused
% prefLog=0:0.5:7;
% prefLin=2.^prefLog;
% sigmaLog=0.5;
% prefLog=asinh(-25:1:25);
prefLog=-4.1:0.5:4.1;
prefLin=-25:1:25;
sigmaLog=0.1;
% sigmaLog=[0.05 0.1 0.2];
%%
% 
% <<FILENAME.PNG>>
% 
sigmaLin=1;
% xLog=-asinh(25):0.01:(max(prefLog)+4*sigmaLog);
xLog=-4.1:0.01:(max(prefLog)+4*sigmaLog);
xLin=-25:0.1:(max(prefLin)+4*sigmaLin);
colours=hsv(length(prefLog));
for whichGaus=1:length(prefLog)
    Gaussians(whichGaus,:)=calculateGaussian(prefLog(whichGaus), sigmaLog, xLog);
    Gaussians(whichGaus,:)=Gaussians(whichGaus,:)./max(Gaussians(whichGaus,:));
end

%Log tuning functions
LogFigure=figure; hold on;
for whichGaus=1:length(prefLog)
    plot(xLog, Gaussians(whichGaus,:), 'color', colours(whichGaus, :), 'LineWidth', 2);
end
xlabel('ILD preference (log scale)');
ylabel('Response amplitude')
xticks(floor(min(prefLog)):floor(max(xLog)));
xticklabels((floor(min(prefLog)):floor(max(xLog))));
axis([-4.1 4.1 0 1])
ax=gca;
ax.FontName='helvetica'
ax.Units='points';
ax.LineWidth=1;
ax.TickLength = [0.012 0.012];
ax.FontSize=16;
% exportgraphics(LogFigure, 'LogTuning.pdf', 'Append', false, 'ContentType', 'vector');

%% Linear tuning functions
LinFigure=figure; hold on;
for whichGaus=1:length(prefLog)
    plot(xLin, Gaussians(whichGaus,:), 'color', colours(whichGaus, :), 'LineWidth', 2);
end
xlabel('Numerosity (linear scale)');
ylabel('Response amplitude')
xticks([2.^(floor(min(prefLog)):floor(max(xLog)))]);
xticklabels([2.^(floor(min(prefLog)):floor(max(xLog)))]);
axis([1 2.^6 0 1])
ax=gca;
ax.FontName='helvetica'
ax.Units='points';
ax.LineWidth=1;
ax.TickLength = [0.012 0.012];
ax.FontSize=16;
% exportgraphics(LinFigure, 'LinearTuning.pdf', 'Append', false, 'ContentType', 'vector');

%ADAPTATION. SET ADAPTER NUMEROSITY HERE
clear all;
adapterLin=1; %<<<<<---------------------------
adapterLog=log2(adapterLin);
%Perhaps good to use a different set of tuning functions, closer together?
prefLog=-1:0.5:7;
prefLin=2.^prefLog;
sigmaLog=0.5;

adapterSigmaLog=sigmaLog; %I believe this spread of adaptation is the same as the sigma of the most adapted neuron, because maths.
xLog=min(prefLog):0.001:(max(prefLog)+4*sigmaLog);
xLin=2.^xLog;
colours=jet(length(prefLog));
for whichGaus=1:length(prefLog)
    Gaussians(whichGaus,:)=calculateGaussian(prefLog(whichGaus), sigmaLog, xLog);
    Gaussians(whichGaus,:)=Gaussians(whichGaus,:)./max(Gaussians(whichGaus,:));
end

adapterGaussian=calculateGaussian(adapterLog, adapterSigmaLog, xLog);
adapterGaussianPerFunction=calculateGaussian(adapterLog, adapterSigmaLog, prefLog);
adapterGaussianPerFunction=adapterGaussianPerFunction./max(adapterGaussian);
adapterGaussian=adapterGaussian./max(adapterGaussian);
%To check
%figure; plot(xLog, adapterGaussian, '-'); hold on; plot(prefLog,adapterGaussianPerFunction);

%In this line, the +1 at the end determines the intensity of adaptation.
%+1 is a maximum supression of 0.5, i.e. 1/(1+1). 
%Smaller number gives more supression
%This simply assumes gaussian amplitudes are scaled, which is too
%simplistic. This is where the divisive normalisation goes.
AdaptedGaussians=Gaussians./(repmat(adapterGaussianPerFunction', [1,size(Gaussians,2)])+1);
AdaptedGaussians=AdaptedGaussians./max(AdaptedGaussians(:));
%Log tuning functions with adaptation
figure; hold on;
for whichGaus=1:length(prefLog)
    plot(xLog, AdaptedGaussians(whichGaus,:), 'color', colours(whichGaus, :), 'LineWidth', 2);
end
plot([adapterLog adapterLog], [0 1], 'color', [0 0 0], 'LineWidth', 1);

xticks(floor(min(prefLog)):floor(max(xLog)));
xticklabels(2.^(floor(min(prefLog)):floor(max(xLog))));
xlabel('Numerosity');
ylabel('Response amplitude')
axis([0 6 0 1]);

%Total response of all neurons under adaptation (Piazza)
figure; 
hold on;
%sumResponse=sum(AdaptedGaussians, 1); %<---Mathematically correct, but complex
sumResponse=1./(adapterGaussian+1); %<---Mathematically wrong, but simpler
plot(xLog, sumResponse./max(sumResponse), 'color', [0 0 0], 'LineWidth', 2);
plot([adapterLog adapterLog], [0 1], 'color', [1 0 0], 'LineWidth', 1);
axis([0 6 0 1]);
xticks(floor(min(prefLog)):floor(max(xLog)));
xticklabels(2.^(floor(min(prefLog)):floor(max(xLog))));
xlabel('Numerosity');
ylabel('Population response amplitude')

%pRF function
clear all;
preferredNum=log2(exp(1.3724));
sigma=log2(exp(1.9786));

%Parameters of plotted gaussians
prefLog=-1:0.5:7;
prefLin=2.^prefLog;
sigmaLog=0.5;
xLog=-6:0.001:(max(prefLog)+4*sigmaLog);
xLin=2.^xLog;
colours=jet(length(prefLog));

sigma=sqrt(sigma.^2-sigmaLog.^2);

for whichGaus=1:length(prefLog)
    Gaussians(whichGaus,:)=calculateGaussian(prefLog(whichGaus), sigmaLog, xLog);
    Gaussians(whichGaus,:)=Gaussians(whichGaus,:)./max(Gaussians(whichGaus,:));
end

pRFGaussian=calculateGaussian(preferredNum, sigma, xLog);
pRFGaussianPerFunction=calculateGaussian(preferredNum, sigma, prefLog);
pRFGaussianPerFunction=pRFGaussianPerFunction./max(pRFGaussian);
pRFGaussian=pRFGaussian./max(pRFGaussian);

figure; plot(xLog, pRFGaussian)
weightedGaussians=Gaussians.*(repmat(pRFGaussianPerFunction', [1,size(Gaussians,2)]));
weightedGaussians=weightedGaussians./max(weightedGaussians(:));
%Log tuning functions with adaptation
figure; hold on;
for whichGaus=1:length(prefLog)
    plot(xLog, weightedGaussians(whichGaus,:), 'color', colours(whichGaus, :), 'LineWidth', 2);
end
plot(xLog, pRFGaussian, 'color', [0 0 0], 'LineWidth', 1);
xticks(floor(min(prefLog)):floor(max(xLog)));
xticklabels(2.^(floor(min(prefLog)):floor(max(xLog))));
xlabel('Numerosity');
ylabel('Response amplitude')
axis([0 6 0 1]);

figure; hold on;
for whichGaus=1:length(prefLog)
    plot(xLin, weightedGaussians(whichGaus,:), 'color', colours(whichGaus, :), 'LineWidth', 2);
end
plot(xLin, pRFGaussian, 'color', [0 0 0], 'LineWidth', 1);
xlabel('Numerosity');
ylabel('Response amplitude')
xticks([0 2.^(0:floor(max(xLog)))]);
xticklabels([0 2.^(0:floor(max(xLog)))]);
axis([0 2.^6 0 1])

%Tuning widths
prefLog=-1:0.5:7;
prefLin=2.^prefLog;
sigmaLog=0.5;
%Nieder's value
%sigmaLog=log2(10^(0.2));

fwhms=sigmaLog.*(2*sqrt(2*log(2)));
fwhms=2.^(prefLog+fwhms./2)-2.^(prefLog-fwhms./2);
figure; plot(prefLin, fwhms)
xlabel('Numerosity');
ylabel('Tuning width (FWHM)')
xticks([0 2.^(0:floor(max(prefLog)))]);
xticklabels([0 2.^(0:floor(max(prefLog)))]);
axis([0 2.^6 0 60])
%Or, for a different range
%axis([0 2.^3 0 8])

%Proportion of neurons (like CMF)
howMany=100000;
prefLog=linspace(0, 6, howMany);
prefLin=2.^prefLog;
for n=1:(max(prefLin)-1);
    count(n)=sum(prefLin>=n & prefLin<(n+1));
end
proportion=count.*100./howMany; %To give a percentage
figure; bar([1.5:1:63.5], proportion); %Percentage in each number increment
xlim([0 64])


%Plots of discriminability (d-prime)
%Nieder's value
sigmaLog=log2(10^(0.2));

%num vs num+1
num1=1:64;
num2=num1+1;
num1Log=log2(num1);
num2Log=log2(num2);
dPrimes=(num2Log-num1Log)./sigmaLog;
figure; plot((num1+num2)./2, dPrimes);
xlabel('Mean Numerosity');
ylabel('Discriminability index (d'', n vs n+1)')
xticks(2.^[0:1:6]);
axis([0 2.^6 0 1.5])

% %num vs 8
% reference=8; %<-- Numerosity compared against
% sigmaLog=log2(10^(0.2));
% num1Low=1:reference;
% num2Low=repmat(reference, size(num1Low));
% num1LowLog=log2(num1Low);
% num2LowLog=log2(num2Low);
% num1Hi=reference:64;
% num2Hi=repmat(reference, size(num1Hi));
% num1HiLog=log2(num1Hi);
% num2HiLog=log2(num2Hi);
% dPrimesLow=(abs(num2LowLog-num1LowLog))./sigmaLog;
% dPrimesHi=(abs(num2HiLog-num1HiLog))./sigmaLog;
% figure; plot(num1Low, dPrimesLow, 'go');
% hold on; plot(num1Hi, dPrimesHi, 'bo');
% xlabel('Numerosity');
% ylabel('Discriminability index (d'', n vs 8)')
% xticks(2.^[0:1:6]);
% axis([0 2.^6 0 5])

%same data plotted as a ratio (for either data set above)
figure; hold on; plot(max([num1; num2])./min([num1; num2]), dPrimes);
%plot(max([num1Hi; num2Hi])./min([num1Hi; num2Hi]), dPrimesHi, 'go');
%plot(max([num1Low; num2Low])./min([num1Low; num2Low]), dPrimesLow, 'bo');
xlabel('Ratio');
ylabel('Discriminability index (d'')')


%pRFs with adaptation
clear all;
adapterLin=20; %<<<<<---------------------------
adapterLog=log2(adapterLin);
%Perhaps good to use a different set of tuning functions, closer together?
prefLog=-1:0.1:7;
prefLin=2.^prefLog;
sigmaLog=0.5;

adapterSigmaLog=sigmaLog; %I believe this spread of adaptation is the same as the sigma of the most adapted neuron, because maths.
xLog=min(prefLog):0.001:(max(prefLog)+4*sigmaLog);
xLin=2.^xLog;
colours=jet(length(prefLog));
for whichGaus=1:length(prefLog)
    Gaussians(whichGaus,:)=calculateGaussian(prefLog(whichGaus), sigmaLog, xLog);
    Gaussians(whichGaus,:)=Gaussians(whichGaus,:)./max(Gaussians(whichGaus,:));
end

adapterGaussian=calculateGaussian(adapterLog, adapterSigmaLog, xLog);
%adapterGaussianPerFunction=calculateGuassian(adapterLog, adapterSigmaLog, prefLog);
adapterGaussianPerFunction=calculateLaplacian(adapterLog, adapterSigmaLog, prefLog);
%adapterGaussianPerFunction=adapterGaussianPerFunction./max(adapterGaussian);
adapterGaussian=adapterGaussian./max(adapterGaussian);

AdaptedGaussians=Gaussians./(repmat(adapterGaussianPerFunction', [1,size(Gaussians,2)])+1);
AdaptedGaussians=AdaptedGaussians./max(AdaptedGaussians(:));

%pRF function
preferredNum=log2(2);%exp(1.3724));
sigma=log2(exp(1.9786));

%Parameters of plotted gaussians
sigma=sqrt(sigma.^2-sigmaLog.^2);

pRFGaussian=calculateGaussian(preferredNum, sigma, xLog);
pRFGaussianPerFunction=calculateGaussian(preferredNum, sigma, prefLog);
pRFGaussianPerFunction=pRFGaussianPerFunction./max(pRFGaussian);
adaptedPRFGaussianPerFunction=pRFGaussianPerFunction./(adapterGaussianPerFunction+1);
adapterSupression=1./(adapterGaussianPerFunction+1);
%adapterSupression=adapterSupression./mean(adapterSupression);

figure; hold on; plot(prefLog, pRFGaussianPerFunction, 'b');
plot(prefLog, adapterSupression, 'k');
plot(prefLog, adaptedPRFGaussianPerFunction, 'r');
xticks(floor(min(prefLog)):floor(max(xLog)));
xticklabels(2.^(floor(min(prefLog)):floor(max(xLog))));
xlabel('Numerosity');
ylabel('Response amplitude')
%axis([0 6 0 1]);

%[prefNumEstAdapted, sigmaEst]=normfit(prefLog, [],[], adaptedPRFGaussianPerFunction);
for prefNum=1:8
    pRFGaussianPerFunction=calculateGaussian(log2(prefNum), sigma, prefLog);
    pRFGaussianPerFunction=pRFGaussianPerFunction./max(pRFGaussian);
    adaptedPRFGaussianPerFunction=pRFGaussianPerFunction.*adapterSupression;
    
    
    [~, prefNumEstAdapted, sigmaEst]=fitgauss(adaptedPRFGaussianPerFunction(prefLin>=1 & prefLin<=8), prefLog(prefLin>=1 & prefLin<=8));
    adaptedPrefNumEstLin(prefNum)=2.^prefNumEstAdapted;
    [~, prefNumEstUnadapted, sigmaEst]=fitgauss(pRFGaussianPerFunction(prefLin>=1 & prefLin<=8), prefLog(prefLin>=1 & prefLin<=8));
    unAdaptedPrefNumEstLin(prefNum)=2.^prefNumEstUnadapted;
end

figure; hold on; plot(unAdaptedPrefNumEstLin, adaptedPrefNumEstLin, 'r'); plot(unAdaptedPrefNumEstLin, unAdaptedPrefNumEstLin, 'k')

pRFGaussian=pRFGaussian./max(pRFGaussian);

figure; plot(xLog, pRFGaussian)
weightedGaussians=Gaussians.*(repmat(pRFGaussianPerFunction', [1,size(Gaussians,2)]));
weightedGaussians=weightedGaussians./max(weightedGaussians(:));
%Log tuning functions with adaptation
figure; hold on;
for whichGaus=1:length(prefLog)
    plot(xLog, weightedGaussians(whichGaus,:), 'color', colours(whichGaus, :), 'LineWidth', 2);
end
plot(xLog, pRFGaussian, 'color', [0 0 0], 'LineWidth', 1);
xticks(floor(min(prefLog)):floor(max(xLog)));
xticklabels(2.^(floor(min(prefLog)):floor(max(xLog))));
xlabel('Numerosity');
ylabel('Response amplitude')
axis([0 6 0 1]);

figure; hold on;
for whichGaus=1:length(prefLog)
    plot(xLin, weightedGaussians(whichGaus,:), 'color', colours(whichGaus, :), 'LineWidth', 2);
end
plot(xLin, pRFGaussian, 'color', [0 0 0], 'LineWidth', 1);
xlabel('Numerosity');
ylabel('Response amplitude')
xticks([0 2.^(0:floor(max(xLog)))]);
xticklabels([0 2.^(0:floor(max(xLog)))]);
axis([0 2.^6 0 1])