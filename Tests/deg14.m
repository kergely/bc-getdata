clear variables
%%
filenames = {"../Adatok/14deg/181106_10Hz_3sec_central_14deg/181106_10Hz_3sec_central_14deg.txt",
            "../../Adatok/14deg/181106_30Hz_3sec_central_14deg/181106_30Hz_3sec_central_14deg.txt",
            "../../Adatok/14deg/181106_50Hz_3sec_central_14deg/181106_50Hz_3sec_central_14deg.txt"};

meas = Measurement(filenames{1});
beta = meas.fit_curve();
gamma = meas.retrofit_curve();
%%
hold on
plot(meas.listloc(),meas.listp(),"bo")
plot(meas.listloc(),beta(1)+meas.listloc()*beta(2))
plot(meas.listloc(),gamma(1)+meas.listloc()*gamma(2))
%legend('Points','Small fit','large fit')