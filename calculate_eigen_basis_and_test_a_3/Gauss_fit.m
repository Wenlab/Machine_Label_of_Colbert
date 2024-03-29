% Plot the histogram on linear scale and semilogy scale and use Gauss to
% fit
%
% input: N*1 numerical array
%
% 2023-10-14, Yixuan Li
%

function Gauss_fit(a_3)

% Calculate histogram data
[histCounts, histEdges] = histcounts(a_3, 'Normalization', 'probability');

% Calculate bin centers
binCenters = (histEdges(1:end-1) + histEdges(2:end)) / 2;

% Fit Gaussian to data
ft = fittype('gauss1'); % Single-term Gaussian
fo = fitoptions(ft);
fo.StartPoint = [max(histCounts), mean(a_3), std(a_3)]; % Starting guess ([amplitude, mean, std])
fitResult = fit(binCenters(:), histCounts(:), ft, fo);

% Create histogram plot
figure;
histogram(a_3, 'Normalization', 'probability');
hold on;

% Plot Gaussian fit
x_fit = linspace(min(binCenters), max(binCenters), 1000);
y_fit = feval(fitResult, x_fit);
plot(x_fit, y_fit, 'r-', 'LineWidth', 2);

xlabel('a_3');
ylabel('pdf');
title('Histogram with Gaussian fit');
hold off;

% Create semilogy plot
figure;
semilogy(binCenters, histCounts, 'bo-');
hold on;

% Plot Gaussian fit in semilogy
semilogy(x_fit, y_fit, 'r-', 'LineWidth', 2);

xlabel('a_3');
ylabel('pdf');
title('Semilogy plot with Gaussian fit');
hold off;

end