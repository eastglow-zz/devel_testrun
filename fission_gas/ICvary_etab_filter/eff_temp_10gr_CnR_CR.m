clear;
close all

Va = 0.0409;  %nm^3/atom
Vtot = 20000*20000; %nm^3 (assuming 1 nm in depth)

fname = './ICvary_CnR_ps_etab/10gr/GPM_GT_ic_from_file_out.csv';
data_10gr_CnR_18 = table2array(readtable(fname));
fname = './ICvary_CR_ps_etab/10gr/GPM_GT_ic_from_file_out.csv';
data_10gr_CR_18 = table2array(readtable(fname));

fname = './10gr1000K_ps_etab/CnR/GPM_GT_ic_from_file_out.csv';
data_10gr_CnR_10 = table2array(readtable(fname));
fname = './10gr1000K_ps_etab/CR/10gr_1000K/GPM_GT_ic_from_file_out.csv';
data_10gr_CR_10 = table2array(readtable(fname));

fname = './ICvary_CnR_ps_etab/10gr_etab_filtered.csv';
data_10gr_CnR_18_f = table2array(readtable(fname));
fname = './ICvary_CR_ps_etab/10gr_etab_filtered.csv';
data_10gr_CR_18_f = table2array(readtable(fname));

fname = './10gr1000K_ps_etab/CnR/etab_filtered.csv';
data_10gr_CnR_10_f = table2array(readtable(fname));
fname = './10gr1000K_ps_etab/CR/etab_filtered.csv';
data_10gr_CR_10_f = table2array(readtable(fname));


time_10gr_CnR_18 = data_10gr_CnR_18(:,1)./ 3600 ./24; %sec to days
time_10gr_CR_18 = data_10gr_CR_18(:,1)./ 3600 ./24; %sec to days
time_10gr_CnR_18_f = data_10gr_CnR_18_f(:,1)./ 3600 ./24; %sec to days
time_10gr_CR_18_f = data_10gr_CR_18_f(:,1)./ 3600 ./24; %sec to days

time_10gr_CnR_10 = data_10gr_CnR_10(:,1)./ 3600 ./24; %sec to days
time_10gr_CR_10 = data_10gr_CR_10(:,1)./ 3600 ./24; %sec to days
time_10gr_CnR_10_f = data_10gr_CnR_10_f(:,1)./ 3600 ./24; %sec to days
time_10gr_CR_10_f = data_10gr_CR_10_f(:,1)./ 3600 ./24; %sec to days


XeConc_10gr_CnR_18 = data_10gr_CnR_18(:,3)*Vtot;
XeConc_10gr_CR_18 = data_10gr_CR_18(:,3)*Vtot;
XeConc_10gr_CnR_10 = data_10gr_CnR_10(:,3)*Vtot;
XeConc_10gr_CR_10 = data_10gr_CR_10(:,3)*Vtot;


volfrac_10gr_CnR_18 = data_10gr_CnR_18(:,6)*Vtot/Va;
volfrac_10gr_CR_18 = data_10gr_CR_18(:,6)*Vtot/Va;
volfrac_10gr_CnR_10 = data_10gr_CnR_10(:,6)*Vtot/Va;
volfrac_10gr_CR_10 = data_10gr_CR_10(:,6)*Vtot/Va;


interGvolFrac_10gr_CnR_18_f = data_10gr_CnR_18_f(:,4)*Vtot/Va;
interGvolFrac_10gr_CR_18_f = data_10gr_CR_18_f(:,4)*Vtot/Va;
interGvolFrac_10gr_CnR_10_f = data_10gr_CnR_10_f(:,4)*Vtot/Va;
interGvolFrac_10gr_CR_10_f = data_10gr_CR_10_f(:,4)*Vtot/Va;


interBubFrac_10gr_CnR_18_f = data_10gr_CnR_18_f(:,3);
interBubFrac_10gr_CR_18_f = data_10gr_CR_18_f(:,3);
interBubFrac_10gr_CnR_10_f = data_10gr_CnR_10_f(:,3);
interBubFrac_10gr_CR_10_f = data_10gr_CR_10_f(:,3);

interGvolFrac_10gr_CnR_18 = interp1(time_10gr_CnR_18_f, interGvolFrac_10gr_CnR_18_f, time_10gr_CnR_18);
interGvolFrac_10gr_CR_18 = interp1(time_10gr_CR_18_f, interGvolFrac_10gr_CR_18_f, time_10gr_CR_18);
interGvolFrac_10gr_CnR_10 = interp1(time_10gr_CnR_10_f, interGvolFrac_10gr_CnR_10_f, time_10gr_CnR_10);
interGvolFrac_10gr_CR_10 = interp1(time_10gr_CR_10_f, interGvolFrac_10gr_CR_10_f, time_10gr_CR_10);

intraGconc_10gr_CnR_18 = XeConc_10gr_CnR_18 + volfrac_10gr_CnR_18;
intraGconc_10gr_CR_18 = XeConc_10gr_CR_18 + volfrac_10gr_CR_18;
intraGconc_10gr_CnR_10 = XeConc_10gr_CnR_10 + volfrac_10gr_CnR_10;
intraGconc_10gr_CR_10 = XeConc_10gr_CR_10 + volfrac_10gr_CR_10;

XeTot_10gr_CnR_18 = interGvolFrac_10gr_CnR_18 + intraGconc_10gr_CnR_18;
XeTot_10gr_CR_18 = interGvolFrac_10gr_CR_18 + intraGconc_10gr_CR_18;
XeTot_10gr_CnR_10 = interGvolFrac_10gr_CnR_10 + intraGconc_10gr_CnR_10;
XeTot_10gr_CR_10 = interGvolFrac_10gr_CR_10 + intraGconc_10gr_CR_10;

XeFracIntra_10gr_CnR_18 = intraGconc_10gr_CnR_18 ./ XeTot_10gr_CnR_18;
XeFracIntra_10gr_CR_18 = intraGconc_10gr_CR_18 ./ XeTot_10gr_CR_18;
XeFracIntra_10gr_CnR_10 = intraGconc_10gr_CnR_10 ./ XeTot_10gr_CnR_10;
XeFracIntra_10gr_CR_10 = intraGconc_10gr_CR_10 ./ XeTot_10gr_CR_10;

% volfrac_10gr_Deff = data_10gr_Deff(:,2);


figure(1)
plot(time_10gr_CnR_18, intraGconc_10gr_CnR_18, 'r-.', 'LineWidth', 2);
hold on;
plot(time_10gr_CR_18, intraGconc_10gr_CR_18, 'r-', 'LineWidth', 2);
plot(time_10gr_CnR_10, intraGconc_10gr_CnR_10, 'k-.', 'LineWidth', 2);
plot(time_10gr_CR_10, intraGconc_10gr_CR_10, 'k-', 'LineWidth', 2);
% plot(time_10gr_Deff, volfrac_10gr_Deff, 'b-', 'LineWidth', 2);


xlim([1 1400]);
% ylim([0 .04]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Xe in intragranular bubbles (atoms)', 'FontSize', 24);

legend('@1800K, no re-solution','@1800K, re-solution', '@1000K, no re-solution', '@1000K, re-solution', 'Location', 'northwest');
hold off;

figure(2)
plot(time_10gr_CnR_18, interGvolFrac_10gr_CnR_18, 'r-.', 'LineWidth', 2);
hold on;
plot(time_10gr_CR_18, interGvolFrac_10gr_CR_18, 'r-', 'LineWidth', 2);
plot(time_10gr_CnR_10, interGvolFrac_10gr_CnR_10, 'k-.', 'LineWidth', 2);
plot(time_10gr_CR_10, interGvolFrac_10gr_CR_10, 'k-', 'LineWidth', 2);

xlim([1 1400]);
% ylim([0 0.04]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Xe in intergranular pores (atoms)', 'FontSize', 24);


legend('@1800K, no re-solution','@1800K, re-solution', '@1000K, no re-solution', '@1000K, re-solution', 'Location', 'northwest');

hold off;

figure(3)
plot(time_10gr_CnR_18, XeConc_10gr_CnR_18/Vtot, 'r-.', 'LineWidth', 2);
hold on;
plot(time_10gr_CR_18, XeConc_10gr_CR_18/Vtot, 'r-', 'LineWidth', 2);
plot(time_10gr_CnR_10, XeConc_10gr_CnR_10/Vtot, 'k-.', 'LineWidth', 2);
plot(time_10gr_CR_10, XeConc_10gr_CR_10/Vtot, 'k-', 'LineWidth', 2);

xlim([1 1400]);
% ylim([0 0.03]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Xe monomer concentration (atoms/nm^3)', 'FontSize', 24);


legend('@1800K, no re-solution','@1800K, re-solution', '@1000K, no re-solution', '@1000K, re-solution', 'Location', 'northeast');

hold off;

figure(4)
plot(time_10gr_CnR_18, XeFracIntra_10gr_CnR_18, 'r-.', 'LineWidth', 2);
hold on;
plot(time_10gr_CR_18, XeFracIntra_10gr_CR_18, 'r-', 'LineWidth', 2);
plot(time_10gr_CnR_10, XeFracIntra_10gr_CnR_10, 'k-.', 'LineWidth', 2);
plot(time_10gr_CR_10, XeFracIntra_10gr_CR_10, 'k-', 'LineWidth', 2);

xlim([1 1400]);
% ylim([0 0.03]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Xe fraction in grains', 'FontSize', 24);


%legend('10 grains, No re-s.','10 grains, Re-s.', '20 grains, No re-s.','20 grains, Re-s.','30 grains, No re-s.', '30 grains, Re-s.', 'Location', 'southeast');
legend('@1800K, no re-solution','@1800K, re-solution', '@1000K, no re-solution', '@1000K, re-solution', 'Location', 'southeast');

hold off;

figure(5)
plot(time_10gr_CnR_18_f, interBubFrac_10gr_CnR_18_f, 'r-.', 'LineWidth', 2);
hold on;
plot(time_10gr_CR_18_f, interBubFrac_10gr_CR_18_f, 'r-', 'LineWidth', 2);
plot(time_10gr_CnR_10_f, interBubFrac_10gr_CnR_10_f, 'k-.', 'LineWidth', 2);
plot(time_10gr_CR_10_f, interBubFrac_10gr_CR_10_f, 'k-', 'LineWidth', 2);

xlim([1 1400]);
% ylim([0 .04]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Intergranular bubble fraction', 'FontSize', 24);

legend('@1800K, no re-solution','@1800K, re-solution', '@1000K, no re-solution', '@1000K, re-solution', 'Location', 'northwest');
hold off;

% 
