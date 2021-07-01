clear;
close all

fname = './10gr/GPM_GT_ic_from_file_out.csv';
data_10gr = table2array(readtable(fname));
fname = './20gr/GPM_GT_ic_from_file_out.csv';
data_20gr = table2array(readtable(fname));
fname = './30gr/GPM_GT_ic_from_file_out.csv';
data_30gr = table2array(readtable(fname));


time_10gr = data_10gr(:,1)./ 3600 ./24; %sec to days
time_20gr = data_20gr(:,1)./ 3600 ./24; %sec to days
time_30gr = data_30gr(:,1)./ 3600 ./24; %sec to days

bubfrac_10gr = data_10gr(:,5);
bubfrac_20gr = data_20gr(:,5);
bubfrac_30gr = data_30gr(:,5);

xeconc_10gr = data_10gr(:,2);
xeconc_20gr = data_20gr(:,2);
xeconc_30gr = data_30gr(:,2);

grnum_10gr = data_10gr(:,3);
grnum_20gr = data_20gr(:,3);
grnum_30gr = data_30gr(:,3);

total_vol = 20000*20000;

ags_10gr = sqrt(total_vol./grnum_10gr)*2/sqrt(3.141592);
ags_20gr = sqrt(total_vol./grnum_20gr)*2/sqrt(3.141592);
ags_30gr = sqrt(total_vol./grnum_30gr)*2/sqrt(3.141592);


figure(1)
plot(time_10gr, bubfrac_10gr, 'r-', 'LineWidth', 2);
hold on;
plot(time_20gr, bubfrac_20gr, 'g-', 'LineWidth', 2);
plot(time_30gr, bubfrac_30gr, 'b-', 'LineWidth', 2);


xlim([1 1400]);
% ylim([0 .1]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Intergranular bubble fraction', 'FontSize', 24);

legend('10 grains', '20 grains', '30 grains', 'Location', 'southeast');
hold off;

figure(2)
plot(time_10gr, xeconc_10gr, 'r-', 'LineWidth', 2);
hold on;
plot(time_20gr, xeconc_20gr, 'g-', 'LineWidth', 2);
plot(time_30gr, xeconc_30gr, 'b-', 'LineWidth', 2);

xlim([1 1400]);
ylim([0 .015]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Average Xe mole fraction', 'FontSize', 24);


legend('10 grains', '20 grains', '30 grains', 'Location', 'southeast');

hold off;

figure(3)
plot(time_10gr, ags_10gr/1000, 'r-', 'LineWidth', 2);
hold on;
plot(time_20gr, ags_20gr/1000, 'g-', 'LineWidth', 2);
plot(time_30gr, ags_30gr/1000, 'b-', 'LineWidth', 2);

xlim([12 1400]);
ylim([0 8]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Average grain size (\mum)', 'FontSize', 24);


legend('10 grains', '20 grains', '30 grains', 'Location', 'southeast');

