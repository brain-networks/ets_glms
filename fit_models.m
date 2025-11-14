clear all
close all
clc

%% Description
%
%   In this script, we read in time series data -- parcel-level Ca++
%   imaging data and behavioral time courses. The goals is to fit lineaer
%   models that explain the behavioral data in terms of:
%
%       1. the z-scored activity of parcel i,
%       2. the z-scored activity of parcel j,
%       3. the element-wise product of those z-scored time series (referred
%          to in our previous work as an 'edge time series').
%
%   This procedure is repeated for all unique {i,j} pairs, populating
%   matrices of regression coefficients.
%
%   We repeat this entire procedure for seven behavioral time courses. For
%   reference, these data come from 'subject 18' in this paper:
%
%       Chen, X., Mu, Y., Hu, Y., Kuan, A. T., Nikitchenko, M.,
%       Randlett, O., ... & Ahrens, M. B. (2018). Brain-wide organization
%       of neuronal activity and convergent sensorimotor transformations in
%       larval zebrafish. Neuron, 100(4), 876-890.
%
%   If you use this code in your own work, please cite the original data
%   source, but also our paper:
%
%       Merritt, H., Mejia, A., & Betzel, R. (2024). The dual
%       interpretation of edge time series: Time-varying connectivity
%       versus statistical interaction. bioRxiv, 2024-08.

%% Analysis

% load data
load data

z = zscore(z);                  % z-score time series

[nt,n] = size(z);               % number of frames, number of parcels
[u,v] = find(triu(ones(n),1));  % upper triangle indices

% outer loop - over behavioral measures
for j = 1:size(b,2)

    % behavior time series
    y = b(:,j);

    % constants
    nobs = length(y);
    dft = nobs - 1;
    dfe = nobs - 4;
    p = 4;

    % more constants
    ybar = mean(y);
    sst = norm(y - ybar)^2;

    % preallocate arrays for rsquared, regression coefficients, and pvalues
    rsqu = zeros(length(u),1);
    betas = zeros(length(u),p);
    pvals = zeros(length(u),p);

    % loop over all node pairs
    for i = 1:length(u)

        % update
        if mod(i,round(length(u)/51)) == 0
            fprintf('behavioral measure %i, %.2f percent complete (%i of %i edges)\n',j,100*i/length(u),i,length(u));
        end

        % matrix of explanatory values
        x = ones(nt,4);
        x(:,1) = z(:,u(i));
        x(:,2) = z(:,v(i));
        x(:,3) = z(:,u(i)).*z(:,v(i));

        % get betas and pvalues
        [Q,R] = qr(x,0);

        % regression coefficients -- could stop here if we didn't want to
        % do states
        beta = R\(Q'*y);

        % behavior predicted by model + residuals
        yhat = x*beta;
        residuals = y - yhat;

        sse = norm(residuals)^2;
        mse = sse./dfe;
        ri = R\eye(p);
        xtxi = ri*ri';
        covb = xtxi*mse;
        se = sqrt(diag(covb));

        % t-statistic, pvalue (from distribution)
        t = beta./se;
        pval = 2*(tcdf(-abs(t),dfe));

        % keep rsquared, betas, and pvalues
        rsqu(i) = 1 - sse./sst;
        betas(i,:) = beta;
        pvals(i,:) = pval;

    end

    % plot the three matrices -- here, we only show upper triangle
    s = zeros(1,3);
    tnames = {'beta_i','beta_j','beta_{ij}'};
    figure;
    for i = 1:3
        m = zeros(n);
        m(triu(ones(n),1) > 0) = betas(:,i);
        s(i) = subplot(1,3,i); imagesc(m); title(tnames{i}); xlabel('parcels'); ylabel('parcels');
    end
    set(s,'clim',[-max(abs(m(:))),max(abs(m(:)))]*0.25);
    drawnow;

end