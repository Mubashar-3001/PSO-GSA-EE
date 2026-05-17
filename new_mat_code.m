%% ============================================================
%  comparison_bars_DOCR.m
%  Bar Chart: PSO-GSA-EE vs Literature
%  PRODUCES: 4 SEPARATE FIGURES, each with its own legend
%  COMPATIBLE: MATLAB R2016a and later
%% ============================================================

clc; clear; close all;

%% ---- 1. DATA -----------------------------------------------

algo3  = {'FAGA','WO','ADE','GA-NLP','MINLP','S.A','PSO','FODWO','FPSOGSA','Proposed'};
time3  = [1.78, 1.46, 4.763, 1.598, 1.727, 1.59, 1.925, 1.422, 1.492, 1.322];

algo8  = {'BBO','DJAYA','CSA','FFA','GA','S.A','GA-NLP','FODWO','FPSOGSA','Proposed'};
time8  = [10.5495, 9.69, 9.8186, 10.069, 11.001, 8.427, 10.95, 6.271, 4.4307, 3.8219];

algo15 = {'MTLBO','GSO','DJAYA','SA','MINLP','FODWO','WO','OJAYA','FPSOGSA','Proposed'};
time15 = [25.815, 13.654, 18.8, 12.227, 14.064, 13.229, 13.539, 15.523, 10.213, 8.29];

algo30 = {'WOA','HWOA','EWSO','CBZMC','IDA','FPSOGSA','Proposed'};
time30 = [15.7139, 14.4646, 27.448, 35.1, 65.642, 8.6123, 6.5241];

algos  = {algo3,  algo8,  algo15,  algo30};
times  = {time3,  time8,  time15,  time30};
titles = {'IEEE 3-Bus System','IEEE 8-Bus System', ...
          'IEEE 15-Bus System','IEEE 30-Bus System'};
save_names = {'Comparison_3bus','Comparison_8bus', ...
              'Comparison_15bus','Comparison_30bus'};

%% ---- 2. COLOURS --------------------------------------------

bar_colors = [
    0.27 0.51 0.71;   % steel blue
    0.17 0.63 0.45;   % teal green
    0.93 0.55 0.14;   % amber
    0.80 0.22 0.26;   % crimson
    0.55 0.34 0.65;   % purple
    0.30 0.68 0.75;   % sky blue
    0.87 0.40 0.15;   % burnt orange
    0.40 0.65 0.30;   % olive green
    0.60 0.40 0.25;   % brown
    0.25 0.25 0.25;   % dark grey  <- Proposed
];

% different star colour per figure
star_colors = [
    0.93 0.75 0.00;   % gold   – 3-bus
    0.85 0.10 0.10;   % red    – 8-bus
    0.10 0.70 0.20;   % green  – 15-bus
    0.10 0.35 0.85;   % blue   – 30-bus
];

%% ---- 3. LOOP: ONE FIGURE PER SYSTEM ------------------------

for s = 1:4

    alg      = algos{s};
    tval     = times{s};
    n        = numel(alg);
    scol     = star_colors(s,:);
    prop_idx = find(strcmpi(alg,'Proposed'));
    ymax     = max(tval);

    % ---- create individual figure ---------------------------
    fig = figure('Units','centimeters', ...
                 'Position',[5+s*2, 5+s*2, 22, 14], ...
                 'Color','white', ...
                 'Name', titles{s});

    ax = axes('Parent',fig, ...
              'FontName','Times New Roman','FontSize',10, ...
              'Box','off','TickDir','out','LineWidth',0.9);
    hold(ax,'on');

    % ---- 3a. INDIVIDUAL COLOURED BARS -----------------------
    bar_h = gobjects(n,1);
    for i = 1:n
        cidx    = mod(i-1, size(bar_colors,1)) + 1;
        bar_h(i)= bar(ax, i, tval(i), 0.65);
        set(bar_h(i), ...
            'FaceColor', bar_colors(cidx,:), ...
            'EdgeColor', bar_colors(cidx,:)*0.60, ...
            'LineWidth', 0.9);
    end

    ylim(ax, [0, ymax * 1.38]);

    % ---- 3b. VALUE LABELS ON BAR TOPS -----------------------
    for i = 1:n
        text(ax, i, tval(i) + ymax*0.016, ...
             num2str(tval(i),'%.4f'), ...
             'HorizontalAlignment','center', ...
             'VerticalAlignment','bottom', ...
             'FontSize',8, ...
             'FontName','Times New Roman', ...
             'FontWeight','bold', ...
             'Color',[0.10 0.10 0.10]);
    end

    % ---- 3c. STAR ON PROPOSED BAR ---------------------------
    star_y  = tval(prop_idx) + ymax * 0.17;
    star_sc = scatter(ax, prop_idx, star_y, 260, ...
                      'p', ...           % pentagram star marker
                      'filled', ...
                      'MarkerFaceColor', scol, ...
                      'MarkerEdgeColor', scol * 0.55, ...
                      'LineWidth', 1.2);

    % ---- 3d. AXES FORMATTING --------------------------------
    xlim(ax, [0.3, n + 0.7]);

    % blank the Proposed auto-tick; redraw bold + coloured
    tick_labels      = alg;
    tick_labels{prop_idx} = '';
    set(ax, 'XTick',             1:n, ...
            'XTickLabel',        tick_labels, ...
            'XTickLabelRotation',38, ...
            'FontName',          'Times New Roman', ...
            'FontSize',          10);

    % bold coloured label for Proposed directly
    text(ax, prop_idx, -ymax * 0.055, 'Proposed', ...
         'HorizontalAlignment','center', ...
         'VerticalAlignment','top', ...
         'FontSize',10, ...
         'FontName','Times New Roman', ...
         'FontWeight','bold', ...
         'Color', scol * 0.75, ...
         'Clipping','off');

    ylabel(ax, 'Operational Time (s)', ...
           'FontSize',12,'FontName','Times New Roman');
    xlabel(ax, 'Algorithm', ...
           'FontSize',12,'FontName','Times New Roman');
    title(ax, titles{s}, ...
          'FontSize',13,'FontName','Times New Roman','FontWeight','bold');

    ax.YGrid         = 'on';
    ax.GridAlpha     = 0.15;
    ax.GridLineStyle = '--';

    % ---- 3e. LEGEND (individual per figure) -----------------
    % Two entries: Proposed bar + Proposed star
    lgd = legend(ax, ...
                 [bar_h(prop_idx), star_sc], ...
                 {'Proposed (PSO-GSA-EE)', ...
                  ['* Best result (' titles{s} ')']}, ...
                 'Location','northeast', ...
                 'FontSize',9.5, ...
                 'FontName','Times New Roman', ...
                 'Box','on', ...
                 'EdgeColor',[0.65 0.65 0.65], ...
                 'Color',[0.97 0.97 0.97]);
    title(lgd, 'Legend', ...
          'FontSize',9,'FontName','Times New Roman');

    hold(ax,'off');

    % ---- 3f. SAVE EACH FIGURE SEPARATELY -------------------
    saveas(fig, [save_names{s} '.png']);   % standard PNG
    saveas(fig, [save_names{s} '.fig']);   % editable MATLAB figure

    % optional high-res (skipped if path error)
    try
        print(fig, '-dpng', '-r300', [save_names{s} '_HD']);
        fprintf('Saved HD: %s_HD.png\n', save_names{s});
    catch
        fprintf('(HD print skipped for %s – standard PNG saved)\n', save_names{s});
    end

    fprintf('Saved: %s.png  |  %s.fig\n', save_names{s}, save_names{s});
end

%% ---- 4. COMMAND WINDOW SUMMARY -----------------------------

fprintf('\n=========================================================\n');
fprintf('  Improvement of Proposed over 2nd Best\n');
fprintf('=========================================================\n');
fprintf('%-10s  %9s  %9s  %12s\n','System','Proposed','2nd Best','Improvement');
fprintf('%s\n', repmat('-',1,46));
sys_names = {'3-bus','8-bus','15-bus','30-bus'};
for s = 1:4
    tval  = times{s};
    alg   = algos{s};
    pidx  = find(strcmpi(alg,'Proposed'));
    T_p   = tval(pidx);
    other = tval;  other(pidx) = inf;
    T_2nd = min(other);
    pct   = (T_2nd - T_p) / T_2nd * 100;
    fprintf('%-10s  %9.4f  %9.4f  %11.2f%%\n', sys_names{s}, T_p, T_2nd, pct);
end
fprintf('=========================================================\n');
fprintf('\nAll figures saved in: %s\n', pwd);