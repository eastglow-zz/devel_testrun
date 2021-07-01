clear;
close all

fname = './ICvary_nCnR_ps_etab/10gr_etab_filtered.csv';
data_10gr_nCnR = table2array(readtable(fname));
fname = './ICvary_CnR_ps_etab/10gr_etab_filtered.csv';
data_10gr_CnR = table2array(readtable(fname));
fname = './ICvary_CR_ps_etab/10gr_etab_filtered.csv';
data_10gr_CR = table2array(readtable(fname));
fname = './ICvary_Deff_ps_etab/10gr_etab_filtered.csv';
data_10gr_Deff = table2array(readtable(fname));


time_10gr_nCnR = data_10gr_nCnR(:,1)./ 3600 ./24; %sec to days
time_10gr_CnR = data_10gr_CnR(:,1)./ 3600 ./24; %sec to days
time_10gr_CR = data_10gr_CR(:,1)./ 3600 ./24; %sec to days
time_10gr_Deff = data_10gr_Deff(:,1)./ 3600 ./24; %sec to days

bubfrac_10gr_nCnR = data_10gr_nCnR(:,2);
bubfrac_10gr_CnR = data_10gr_CnR(:,2);
bubfrac_10gr_CR = data_10gr_CR(:,2);
bubfrac_10gr_Deff = data_10gr_Deff(:,2);


figure(1)
plot(time_10gr_nCnR, bubfrac_10gr_nCnR, 'k-', 'LineWidth', 2);
hold on;
plot(time_10gr_CnR, bubfrac_10gr_CnR, 'r-', 'LineWidth', 2);
plot(time_10gr_CR, bubfrac_10gr_CR, 'g-', 'LineWidth', 2);
plot(time_10gr_Deff, bubfrac_10gr_Deff, 'b-', 'LineWidth', 2);


xlim([1 1400]);
% ylim([0 .04]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Intergranular bubble fraction', 'FontSize', 24);

legend('No clustering & no re-solution', 'Clustering & no re-solution', 'Clustering & re-solution', 'Effective diffusion', 'Location', 'northwest');
hold off;
% 
% figure(2)
% plot(time_10gr_Deff, bubfrac_10gr_Deff, 'r-', 'LineWidth', 2);
% hold on;
% plot(time_20gr_Deff, bubfrac_20gr_Deff, 'g-', 'LineWidth', 2);
% plot(time_30gr_Deff, bubfrac_30gr_Deff, 'b-', 'LineWidth', 2);
% 
% xlim([1 1400]);
% ylim([0 0.04]);
% 
% a = get(gca,'XTickLabel');
% set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
% xlabel('Time (days)', 'FontSize', 24);
% ylabel('Intergranular bubble fraction', 'FontSize', 24);
% 
% 
% legend('10 grains', '20 grains', '30 grains', 'Location', 'southeast');
% 
% hold off;
% 
% figure(3)
% plot(time_10gr_CnR, bubfrac_10gr_CnR, 'r-', 'LineWidth', 2);
% hold on;
% plot(time_10gr_Deff, bubfrac_10gr_Deff, 'g-', 'LineWidth', 2);
% 
% xlim([1 1400]);
% ylim([0 0.03]);
% 
% a = get(gca,'XTickLabel');
% set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
% xlabel('Time (days)', 'FontSize', 24);
% ylabel('Intergranular bubble fraction', 'FontSize', 24);
% 
% 
% legend('Clustering & No Re-solution', 'Standalone MARMOT with D_{eff}', 'Location', 'southeast');
% 
