%file PlotLambda.m
%brief Plots the lambda values at different Reynolds numbers

clear variables;
filenames_BCalap_length = {'../Adatok/BC alap/10Hz/3sec_jobb/180925_BC_alap_10Hz_3sec_jobb.txt',...
    '../Adatok/BC alap/10Hz/3sec_bal/180925_BC_alap.txt',...
    '../Adatok/BC alap/10Hz/10sec_jobb/180925_BC_alap_10Hz_10sec_jobb.txt',...
    '../Adatok/BC alap/10Hz/10sec_bal/180925_BC_alap_10Hz_10sec_bal.txt',...
    '../Adatok/BC alap/10Hz/20sec_jobb/180925_BC_alap_10Hz_20sec_jobb.txt',...
    '../Adatok/BC alap/10Hz/20sec_bal/180925_BC_alap_10Hz_20sec_bal.txt'};

filenames_0Deg = {'../Adatok/0deg/10Hz_3sec_bal/181005_10Hz_3sec_bal_0deg.txt',...
    '../Adatok/0deg/20Hz_3sec_bal/181005_20Hz_3sec_bal_0deg.txt',...
    '../Adatok/0deg/30Hz_3sec_bal/181005_30Hz_3sec_bal_0deg.txt',...
    '../Adatok/0deg/40Hz_3sec_bal/181005_40Hz_3sec_bal_0deg.txt',...
    '../Adatok/0deg/50Hz_3sec_bal/181005_50Hz_3sec_bal_0deg.txt'};
filenames_empty = {'../Adatok/BC alap/10Hz/3sec_bal/180925_BC_alap.txt',...
    '../Adatok/BC alap/20Hz/3sec_bal/181002_BC_alap_20Hz_3sec_bal.txt',...
    '../Adatok/BC alap/30Hz/3sec_bal/181002_BC_alap_30Hz_3sec_bal.txt',...
    '../Adatok/BC alap/40Hz/3sec_bal/181002_BC_alap_40Hz_3sec_bal.txt',...
    '../Adatok/BC alap/50Hz/3sec_bal/181002_BC_alap_50Hz_3sec_bal.txt'};
filenames_5Deg = {'../Adatok/5deg/10Hz_3sec_bal/181009_10Hz_3sec_bal_5deg.txt',...
    '../Adatok/5deg/20Hz_3sec_bal/181009_20Hz_3sec_bal_5deg.txt',...
    '../Adatok/5deg/30Hz_3sec_bal/181009_30Hz_3sec_bal_5deg.txt',...
    '../Adatok/5deg/40Hz_3sec_bal/181009_40Hz_3sec_bal_5deg.txt',...
    '../Adatok/5deg/50Hz_3sec_bal/181009_50Hz_3sec_bal_5deg.txt'};
filenames_10Deg = {'../Adatok/10deg/10Hz_3sec_bal/181009_10Hz_3sec_bal_10deg.txt',...
    '../Adatok/10deg/20Hz_3sec_bal/181009_20Hz_3sec_bal_10deg.txt',...
    '../Adatok/10deg/30Hz_3sec_bal/181009_30Hz_3sec_bal_10deg.txt',...
    '../Adatok/10deg/40Hz_3sec_bal/181009_40Hz_3sec_bal_10deg.txt',...
    '../Adatok/10deg/50Hz_3sec_bal/181009_50Hz_3sec_bal_10deg.txt'};


titles = {'10 Hz','20 Hz','30 Hz','40 Hz','50 Hz'};
savefilenames = {'10Hz','20Hz','30Hz','40Hz','50Hz'};

Res = zeros(5,4);
lambda = zeros(5,4);

test = {0,0,0,0};

for i=1:5
    test{1} = Measurement(filenames_empty{i});
    test{2} = Measurement(filenames_0Deg{i});
    test{3} = Measurement(filenames_5Deg{i});
    test{4} = Measurement(filenames_10Deg{i});
    for j=1:4
        lambda(i,j) = test{j}.lambda();
        Re = test{j}.Re();
        Res(i,j) = Re(1);
    end
end

hold on
plot(Res(1:end,1),lambda(1:end,1),'bo')
plot(Res(:,2),lambda(:,2),'rx')
plot(Res(:,3),lambda(:,3),'ks')
plot(Res(:,4),lambda(:,4),'g*')
plot(linspace(0,2e5),arrayfun(@Hidsima,linspace(0,2e5)))
plot(linspace(0,2e5),arrayfun(@Blasius,linspace(0,2e5)))
legend('Üres','0 szögű BC','5 fokos BC','10 fokos BC','Hidraulikailag sima cső','Blasius képlet')
title('\lambda')
xlabel('Reynolds-szám')
xlim([0,2e5])
ylabel('\lambda')
saveas(gcf,'Lambdak_uj.png')