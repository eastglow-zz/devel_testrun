clear;
close all

fname = './CnR/GPM_GT_ic_from_file_out.csv';
data_CnR = table2array(readtable(fname));
fname = './CR/GPM_GT_ic_from_file_out.csv';
data_CR = table2array(readtable(fname));


time_CnR = data_CnR(:,1)./ 3600 ./24; %sec to days
time_CR = data_CR(:,1)./ 3600 ./24; %sec to days

intporefrac_CnR = data_CnR(:,6);
intporefrac_CR = data_CR(:,6);


figure(1)
plot(time_CnR, intporefrac_CnR, 'r-', 'LineWidth', 2);
hold on;
plot(time_CR, intporefrac_CR, 'g-', 'LineWidth', 2);



xlim([1 1400]);
% ylim([0 .04]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Time (days)', 'FontSize', 24);
ylabel('Intragranular bubble volume fraction', 'FontSize', 24);

legend('Clustering & No Re-solution', 'Clustering & Re-solution', 'Location', 'southeast');
hold off;



