filenames_BCalap_length = {'../Adatok/BC alap/10Hz/3sec_bal/180925_BC_alap.txt',...
    '../Adatok/BC alap/20Hz/3sec_bal/181002_BC_alap_20Hz_3sec_bal.txt',...
    '../Adatok/BC alap/30Hz/3sec_bal/181002_BC_alap_30Hz_3sec_bal.txt',...
    '../Adatok/BC alap/40Hz/3sec_bal/181002_BC_alap_40Hz_3sec_bal.txt',...
    '../Adatok/BC alap/50Hz/3sec_bal/181002_BC_alap_50Hz_3sec_bal.txt'};

meas = Measurement(filenames_BCalap_length{1});
beta = meas.fit_curve();
gamma = meas.retrofit_curve();

hold on
plot(meas.listloc(),meas.listp(),'ob')
plot(meas.listloc(),beta(1)+meas.listloc()*beta(2))
plot(meas.listloc(),gamma(1)+meas.listloc()*gamma(2))


v = meas.flow();
beta = meas.fit_curve();
load constants.mat D_small nu
D_small;
2*beta(2)*D_small/(v(1)*v(1)*1.2);
Hidsima(v(1)*D_small/nu);

ylabel('Nyomásesés [Pa]')
xlabel("Hossz [m]")
saveas(gcf,'illesztes.png')

meas.BCloss_theor()
meas.BCloss_real()