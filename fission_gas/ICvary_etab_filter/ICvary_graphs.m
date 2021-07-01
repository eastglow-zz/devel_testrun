clear;
close all

fname = './ICvary_CR_ps_etab/10gr/GPM_GT_ic_from_file_out.csv';
data_10gr_CR = table2array(readtable(fname));
fname = './ICvary_CR_ps_etab/20gr/GPM_GT_ic_from_file_out.csv';
data_20gr_CR = table2array(readtable(fname));
fname = './ICvary_CR_ps_etab/30gr/GPM_GT_ic_from_file_out.csv';
data_30gr_CR = table2array(readtable(fname));


fname = './ICvary_CR_ps_etab/10gr_etab_filtered.csv';
data_10gr_CR_f = table2array(readtable(fname));
fname = './ICvary_CR_ps_etab/20gr_etab_filtered.csv';
data_20gr_CR_f = table2array(readtable(fname));
fname = './ICvary_CR_ps_etab/30gr_etab_filtered.csv';
data_30gr_CR_f = table2array(readtable(fname));


time_10gr_CR = data_10gr_CR(:,1)./ 3600 ./24; %sec to days
time_20gr_CR = data_20gr_CR(:,1)./ 3600 ./24; %sec to days
time_30gr_CR = data_30gr_CR(:,1)./ 3600 ./24; %sec to days

time_10gr_CR_f = data_10gr_CR_f(:,1)./ 3600 ./24; %sec to days
time_20gr_CR_f = data_20gr_CR_f(:,1)./ 3600 ./24; %sec to days
time_30gr_CR_f = data_30gr_CR_f(:,1)./ 3600 ./24; %sec to days

bubfrac_10gr_CR = data_10gr_CR_f(:,2);
bubfrac_20gr_CR = data_20gr_CR_f(:,2);
bubfrac_30gr_CR = data_30gr_CR_f(:,2);

volfrac_10gr_CR = data_10gr_CR(:,6);
volfrac_20gr_CR = data_20gr_CR(:,6);
volfrac_30gr_CR = data_30gr_CR(:,6);

figure(1)
plot(time_10gr_CR_f, bubfrac_10gr_CR, 'r-', 'LineWidth', 2);
hold on;
plot(time_20gr_CR_f, bubfrac_20gr_CR, 'g-', 'LineWidth', 2);
plot(time_30gr_CR_f, bubfrac_30gr_CR, 'b-', 'LineWidth', 2);


xlim([1 1400]);
% ylim([0 .04]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Intergranular pore fraction', 'FontSize', 24);

legend('10 grains', '20 grains', '30 grains', 'Location', 'northwest');

hold off;

figure(2)
plot(time_10gr_CR, volfrac_10gr_CR, 'r-', 'LineWidth', 2);
hold on;
plot(time_20gr_CR, volfrac_20gr_CR, 'g-', 'LineWidth', 2);
plot(time_30gr_CR, volfrac_30gr_CR, 'b-', 'LineWidth', 2);


xlim([1 1400]);
% ylim([0 .04]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Intragranular bubble fraction', 'FontSize', 24);

legend('10 grains', '20 grains', '30 grains', 'Location', 'northwest');



