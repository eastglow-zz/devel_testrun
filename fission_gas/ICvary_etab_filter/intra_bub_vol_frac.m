clear;
close all

Va = 0.0409;  %nm^3/atom
Vtot = 20000*20000; %nm^3 (assuming 1 nm in depth)

fname = './ICvary_nCnR_ps_etab/10gr/GPM_GT_ic_from_file_out.csv';
data_10gr_nCnR = table2array(readtable(fname));
fname = './ICvary_CnR_ps_etab/10gr/GPM_GT_ic_from_file_out.csv';
data_10gr_CnR = table2array(readtable(fname));
fname = './ICvary_CR_ps_etab/10gr/GPM_GT_ic_from_file_out.csv';
data_10gr_CR = table2array(readtable(fname));

fname = './ICvary_nCnR_ps_etab/10gr_etab_filtered.csv';
data_10gr_nCnR_f = table2array(readtable(fname));
fname = './ICvary_CnR_ps_etab/10gr_etab_filtered.csv';
data_10gr_CnR_f = table2array(readtable(fname));
fname = './ICvary_CR_ps_etab/10gr_etab_filtered.csv';
data_10gr_CR_f = table2array(readtable(fname));

fname = './ICvary_Deff_ps_etab/10gr/GPM_GT_ic_from_file_out.csv';
data_10gr_Deff = table2array(readtable(fname));

time_10gr_nCnR = data_10gr_nCnR(:,1)./ 3600 ./24; %sec to days
time_10gr_CnR = data_10gr_CnR(:,1)./ 3600 ./24; %sec to days
time_10gr_CR = data_10gr_CR(:,1)./ 3600 ./24; %sec to days

time_10gr_nCnR_f = data_10gr_nCnR_f(:,1)./ 3600 ./24; %sec to days
time_10gr_CnR_f = data_10gr_CnR_f(:,1)./ 3600 ./24; %sec to days
time_10gr_CR_f = data_10gr_CR_f(:,1)./ 3600 ./24; %sec to days

time_10gr_Deff = data_10gr_Deff(:,1)./ 3600 ./24; %sec to days

XeConc_10gr_nCnR = data_10gr_nCnR(:,3)*Vtot;
XeConc_10gr_CnR = data_10gr_CnR(:,3)*Vtot;
XeConc_10gr_CR = data_10gr_CR(:,3)*Vtot;

volfrac_10gr_nCnR = data_10gr_nCnR(:,6)*Vtot/Va;
volfrac_10gr_CnR = data_10gr_CnR(:,6)*Vtot/Va;
volfrac_10gr_CR = data_10gr_CR(:,6)*Vtot/Va;

interGvolFrac_10gr_nCnR_f = data_10gr_nCnR_f(:,4)*Vtot/Va;
interGvolFrac_10gr_CnR_f = data_10gr_CnR_f(:,4)*Vtot/Va;
interGvolFrac_10gr_CR_f = data_10gr_CR_f(:,4)*Vtot/Va;

interGvolFrac_10gr_nCnR = interp1(time_10gr_nCnR_f, interGvolFrac_10gr_nCnR_f, time_10gr_nCnR);
interGvolFrac_10gr_CnR = interp1(time_10gr_CnR_f, interGvolFrac_10gr_CnR_f, time_10gr_CnR);
interGvolFrac_10gr_CR = interp1(time_10gr_CR_f, interGvolFrac_10gr_CR_f, time_10gr_CR);

intraGconc_10gr_nCnR = XeConc_10gr_nCnR + volfrac_10gr_nCnR;
intraGconc_10gr_CnR = XeConc_10gr_CnR + volfrac_10gr_CnR;
intraGconc_10gr_CR = XeConc_10gr_CR + volfrac_10gr_CR;

XeTot_10gr_nCnR = interGvolFrac_10gr_nCnR + intraGconc_10gr_nCnR;
XeTot_10gr_CnR = interGvolFrac_10gr_CnR + intraGconc_10gr_CnR;
XeTot_10gr_CR = interGvolFrac_10gr_CR + intraGconc_10gr_CR;

XeFracIntra_10gr_nCnR = intraGconc_10gr_nCnR ./ XeTot_10gr_nCnR;
XeFracIntra_10gr_CnR = intraGconc_10gr_CnR ./ XeTot_10gr_CnR;
XeFracIntra_10gr_CR = intraGconc_10gr_CR ./ XeTot_10gr_CR;

% volfrac_10gr_Deff = data_10gr_Deff(:,2);


figure(1)
plot(time_10gr_nCnR, intraGconc_10gr_nCnR, 'r-.', 'LineWidth', 2);
hold on;
plot(time_10gr_CnR, intraGconc_10gr_CnR, 'g-.', 'LineWidth', 2);
plot(time_10gr_CR, intraGconc_10gr_CR, 'k-', 'LineWidth', 2);
% plot(time_10gr_Deff, volfrac_10gr_Deff, 'b-', 'LineWidth', 2);


xlim([1 1400]);
% ylim([0 .04]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Xe in intragranular bubbles (atoms)', 'FontSize', 24);

legend('No clustering','Re-solution off', 'Re-solution on', 'Location', 'northwest');
hold off;

figure(2)
plot(time_10gr_nCnR, interGvolFrac_10gr_nCnR, 'r-.', 'LineWidth', 2);
hold on;
plot(time_10gr_CnR, interGvolFrac_10gr_CnR, 'g-.', 'LineWidth', 2);
plot(time_10gr_CR, interGvolFrac_10gr_CR, 'k-', 'LineWidth', 2);

xlim([1 1400]);
% ylim([0 0.04]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Xe in intergranular pores (atoms)', 'FontSize', 24);


legend('No clustering','Re-solution off', 'Re-solution on', 'Location', 'northwest');

hold off;

figure(3)
plot(time_10gr_nCnR, XeConc_10gr_nCnR, 'r-.', 'LineWidth', 2);
hold on;
plot(time_10gr_CnR, XeConc_10gr_CnR, 'g-.', 'LineWidth', 2);
plot(time_10gr_CR, XeConc_10gr_CR, 'k-', 'LineWidth', 2);

xlim([1 1400]);
% ylim([0 0.03]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Xe monomer concentration', 'FontSize', 24);


legend('No clustering','Re-solution off', 'Re-solution on', 'Location', 'east');

hold off;

figure(4)
plot(time_10gr_nCnR, XeFracIntra_10gr_nCnR, 'k-', 'LineWidth', 2);
hold on;
plot(time_10gr_CnR, XeFracIntra_10gr_CnR, 'r-', 'LineWidth', 2);
plot(time_10gr_CR, XeFracIntra_10gr_CR, 'g-', 'LineWidth', 2);

xlim([1 1400]);
% ylim([0 0.03]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Xe fraction in grains', 'FontSize', 24);


legend('No clustering & no re-solution','Clustering & no re-solution', 'Clustering & re-solution', 'Location', 'east');
% 
