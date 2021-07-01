clear;
close all

Va = 0.0409;  %nm^3/atom
Vtot = 20000*20000; %nm^3 (assuming 1 nm in depth)

fname = './ICvary_CnR_ps_etab/10gr/GPM_GT_ic_from_file_out.csv';
data_10gr_CnR = table2array(readtable(fname));
fname = './ICvary_CnR_ps_etab/20gr/GPM_GT_ic_from_file_out.csv';
data_20gr_CnR = table2array(readtable(fname));
fname = './ICvary_CnR_ps_etab/30gr/GPM_GT_ic_from_file_out.csv';
data_30gr_CnR = table2array(readtable(fname));

fname = './ICvary_CR_ps_etab/10gr/GPM_GT_ic_from_file_out.csv';
data_10gr_CR = table2array(readtable(fname));
fname = './ICvary_CR_ps_etab/20gr/GPM_GT_ic_from_file_out.csv';
data_20gr_CR = table2array(readtable(fname));
fname = './ICvary_CR_ps_etab/30gr/GPM_GT_ic_from_file_out.csv';
data_30gr_CR = table2array(readtable(fname));

fname = './ICvary_CnR_ps_etab/10gr_etab_filtered.csv';
data_10gr_CnR_f = table2array(readtable(fname));
fname = './ICvary_CnR_ps_etab/20gr_etab_filtered.csv';
data_20gr_CnR_f = table2array(readtable(fname));
fname = './ICvary_CnR_ps_etab/30gr_etab_filtered.csv';
data_30gr_CnR_f = table2array(readtable(fname));

fname = './ICvary_CR_ps_etab/10gr_etab_filtered.csv';
data_10gr_CR_f = table2array(readtable(fname));
fname = './ICvary_CR_ps_etab/20gr_etab_filtered.csv';
data_20gr_CR_f = table2array(readtable(fname));
fname = './ICvary_CR_ps_etab/30gr_etab_filtered.csv';
data_30gr_CR_f = table2array(readtable(fname));

fname = './ICvary_Deff_ps_etab/10gr/GPM_GT_ic_from_file_out.csv';
data_10gr_Deff = table2array(readtable(fname));

time_10gr_CnR = data_10gr_CnR(:,1)./ 3600 ./24; %sec to days
time_20gr_CnR = data_20gr_CnR(:,1)./ 3600 ./24; %sec to days
time_30gr_CnR = data_30gr_CnR(:,1)./ 3600 ./24; %sec to days

time_10gr_CR = data_10gr_CR(:,1)./ 3600 ./24; %sec to days
time_20gr_CR = data_20gr_CR(:,1)./ 3600 ./24; %sec to days
time_30gr_CR = data_30gr_CR(:,1)./ 3600 ./24; %sec to days

time_10gr_CnR_f = data_10gr_CnR_f(:,1)./ 3600 ./24; %sec to days
time_20gr_CnR_f = data_20gr_CnR_f(:,1)./ 3600 ./24; %sec to days
time_30gr_CnR_f = data_30gr_CnR_f(:,1)./ 3600 ./24; %sec to days

time_10gr_CR_f = data_10gr_CR_f(:,1)./ 3600 ./24; %sec to days
time_20gr_CR_f = data_20gr_CR_f(:,1)./ 3600 ./24; %sec to days
time_30gr_CR_f = data_30gr_CR_f(:,1)./ 3600 ./24; %sec to days

time_10gr_Deff = data_10gr_Deff(:,1)./ 3600 ./24; %sec to days

XeConc_10gr_CnR = data_10gr_CnR(:,3)*Vtot;
XeConc_20gr_CnR = data_20gr_CnR(:,3)*Vtot;
XeConc_30gr_CnR = data_30gr_CnR(:,3)*Vtot;
XeConc_10gr_CR = data_10gr_CR(:,3)*Vtot;
XeConc_20gr_CR = data_20gr_CR(:,3)*Vtot;
XeConc_30gr_CR = data_30gr_CR(:,3)*Vtot;

volfrac_10gr_CnR = data_10gr_CnR(:,6)*Vtot/Va;
volfrac_20gr_CnR = data_20gr_CnR(:,6)*Vtot/Va;
volfrac_30gr_CnR = data_30gr_CnR(:,6)*Vtot/Va;
volfrac_10gr_CR = data_10gr_CR(:,6)*Vtot/Va;
volfrac_20gr_CR = data_20gr_CR(:,6)*Vtot/Va;
volfrac_30gr_CR = data_30gr_CR(:,6)*Vtot/Va;

interGvolFrac_10gr_CnR_f = data_10gr_CnR_f(:,4)*Vtot/Va;
interGvolFrac_20gr_CnR_f = data_20gr_CnR_f(:,4)*Vtot/Va;
interGvolFrac_30gr_CnR_f = data_30gr_CnR_f(:,4)*Vtot/Va;
interGvolFrac_10gr_CR_f = data_10gr_CR_f(:,4)*Vtot/Va;
interGvolFrac_20gr_CR_f = data_20gr_CR_f(:,4)*Vtot/Va;
interGvolFrac_30gr_CR_f = data_30gr_CR_f(:,4)*Vtot/Va;

interBubFrac_10gr_CnR_f = data_10gr_CnR_f(:,3);
interBubFrac_20gr_CnR_f = data_20gr_CnR_f(:,3);
interBubFrac_30gr_CnR_f = data_30gr_CnR_f(:,3);
interBubFrac_10gr_CR_f = data_10gr_CR_f(:,3);
interBubFrac_20gr_CR_f = data_20gr_CR_f(:,3);
interBubFrac_30gr_CR_f = data_30gr_CR_f(:,3);

interGvolFrac_10gr_CnR = interp1(time_10gr_CnR_f, interGvolFrac_10gr_CnR_f, time_10gr_CnR);
interGvolFrac_20gr_CnR = interp1(time_20gr_CnR_f, interGvolFrac_20gr_CnR_f, time_20gr_CnR);
interGvolFrac_30gr_CnR = interp1(time_30gr_CnR_f, interGvolFrac_30gr_CnR_f, time_30gr_CnR);
interGvolFrac_10gr_CR = interp1(time_10gr_CR_f, interGvolFrac_10gr_CR_f, time_10gr_CR);
interGvolFrac_20gr_CR = interp1(time_20gr_CR_f, interGvolFrac_20gr_CR_f, time_20gr_CR);
interGvolFrac_30gr_CR = interp1(time_30gr_CR_f, interGvolFrac_30gr_CR_f, time_30gr_CR);

intraGconc_10gr_CnR = XeConc_10gr_CnR + volfrac_10gr_CnR;
intraGconc_20gr_CnR = XeConc_20gr_CnR + volfrac_20gr_CnR;
intraGconc_30gr_CnR = XeConc_30gr_CnR + volfrac_30gr_CnR;
intraGconc_10gr_CR = XeConc_10gr_CR + volfrac_10gr_CR;
intraGconc_20gr_CR = XeConc_20gr_CR + volfrac_20gr_CR;
intraGconc_30gr_CR = XeConc_30gr_CR + volfrac_30gr_CR;

XeTot_10gr_CnR = interGvolFrac_10gr_CnR + intraGconc_10gr_CnR;
XeTot_20gr_CnR = interGvolFrac_20gr_CnR + intraGconc_20gr_CnR;
XeTot_30gr_CnR = interGvolFrac_30gr_CnR + intraGconc_30gr_CnR;
XeTot_10gr_CR = interGvolFrac_10gr_CR + intraGconc_10gr_CR;
XeTot_20gr_CR = interGvolFrac_20gr_CR + intraGconc_20gr_CR;
XeTot_30gr_CR = interGvolFrac_30gr_CR + intraGconc_30gr_CR;

XeFracIntra_10gr_CnR = intraGconc_10gr_CnR ./ XeTot_10gr_CnR;
XeFracIntra_20gr_CnR = intraGconc_20gr_CnR ./ XeTot_20gr_CnR;
XeFracIntra_30gr_CnR = intraGconc_30gr_CnR ./ XeTot_30gr_CnR;
XeFracIntra_10gr_CR = intraGconc_10gr_CR ./ XeTot_10gr_CR;
XeFracIntra_20gr_CR = intraGconc_20gr_CR ./ XeTot_20gr_CR;
XeFracIntra_30gr_CR = intraGconc_30gr_CR ./ XeTot_30gr_CR;

% volfrac_10gr_Deff = data_10gr_Deff(:,2);


figure(1)
plot(time_10gr_CR, intraGconc_10gr_CR, 'r-.', 'LineWidth', 2);
hold on;
plot(time_20gr_CR, intraGconc_20gr_CR, 'g-.', 'LineWidth', 2);
plot(time_30gr_CR, intraGconc_30gr_CR, 'k-', 'LineWidth', 2);
% plot(time_10gr_Deff, volfrac_10gr_Deff, 'b-', 'LineWidth', 2);


xlim([1 1400]);
% ylim([0 .04]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Xe in intragranular bubbles (atoms)', 'FontSize', 24);

legend('10 grains','20 grains', '30 grains', 'Location', 'northwest');
hold off;

figure(2)
plot(time_10gr_CR, interGvolFrac_10gr_CR, 'r-.', 'LineWidth', 2);
hold on;
plot(time_20gr_CR, interGvolFrac_20gr_CR, 'g-.', 'LineWidth', 2);
plot(time_30gr_CR, interGvolFrac_30gr_CR, 'k-', 'LineWidth', 2);

xlim([1 1400]);
% ylim([0 0.04]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Xe in intergranular pores (atoms)', 'FontSize', 24);


legend('10 grains','20 grains', '30 grains', 'Location', 'northwest');

hold off;

figure(3)
plot(time_10gr_CR, XeConc_10gr_CR, 'k-.', 'LineWidth', 2);
hold on;
plot(time_20gr_CR, XeConc_20gr_CR, 'r-.', 'LineWidth', 2);
plot(time_30gr_CR, XeConc_30gr_CR, 'g-', 'LineWidth', 2);

xlim([1 1400]);
% ylim([0 0.03]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Xe monomer concentration', 'FontSize', 24);


legend('10 grains','20 grains', '30 grains', 'Location', 'east');

hold off;

figure(4)
%plot(time_10gr_CnR, XeFracIntra_10gr_CnR, 'k-.', 'LineWidth', 2);
hold on;
plot(time_10gr_CR, XeFracIntra_10gr_CR, 'k-', 'LineWidth', 2);
%plot(time_20gr_CnR, XeFracIntra_20gr_CnR, 'r-.', 'LineWidth', 2);
plot(time_20gr_CR, XeFracIntra_20gr_CR, 'r-', 'LineWidth', 2);
%plot(time_30gr_CnR, XeFracIntra_30gr_CnR, 'g-.', 'LineWidth', 2);
plot(time_30gr_CR, XeFracIntra_30gr_CR, 'g-', 'LineWidth', 2);

xlim([1 1400]);
% ylim([0 0.03]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Xe fraction in grains', 'FontSize', 24);


%legend('10 grains, No re-s.','10 grains, Re-s.', '20 grains, No re-s.','20 grains, Re-s.','30 grains, No re-s.', '30 grains, Re-s.', 'Location', 'southeast');
legend('10 grains','20 grains', '30 grains', 'Location', 'southeast');

hold off;

figure(5)
plot(time_10gr_CR_f, interBubFrac_10gr_CR_f, 'k-', 'LineWidth', 2);
hold on;
plot(time_20gr_CR_f, interBubFrac_20gr_CR_f, 'r-', 'LineWidth', 2);
plot(time_30gr_CR_f, interBubFrac_30gr_CR_f, 'g-', 'LineWidth', 2);
% plot(time_10gr_Deff, volfrac_10gr_Deff, 'b-', 'LineWidth', 2);


xlim([1 1400]);
% ylim([0 .04]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Intergranular bubble fraction', 'FontSize', 24);

legend('10 grains','20 grains', '30 grains', 'Location', 'northwest');
hold off;

% 
