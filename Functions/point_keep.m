clear variables;
filenames_BCalap_length = {'../Adatok/BC alap/10Hz/3sec_bal/180925_BC_alap.txt',...
    '../Adatok/BC alap/20Hz/3sec_bal/181002_BC_alap_20Hz_3sec_bal.txt',...
    '../Adatok/BC alap/30Hz/3sec_bal/181002_BC_alap_30Hz_3sec_bal.txt',...
    '../Adatok/BC alap/40Hz/3sec_bal/181002_BC_alap_40Hz_3sec_bal.txt',...
    '../Adatok/BC alap/50Hz/3sec_bal/181002_BC_alap_50Hz_3sec_bal.txt'};


load constants.mat small_end
for num=5:5
    meas = Measurement(filenames_BCalap_length{num});
    listp = meas.listp();
    %deltap2 = deltap(1:small_end);
    %L = ones(small_end,2);
    locs = meas.listloc();
    %L(:,2) = locs(1:small_end);
%     hold on
%     plot(meas.listloc(),meas.listp(),"xr")
%     plot(meas.listloc(),beta(1)+beta(2)*meas.listloc())
    err = 2;
    good = 1:small_end;
    cycles = 0;
    while cycles <5
        %disp(cycles)
        bad = 1:length(good);
        cycles = cycles+1;
        deltap = listp(good);
        L = ones(length(good),2);
        L(:,2)=locs(good);
        beta = L\deltap;
        for i=1:length(good)
            loc = L(i,2);
            max = (1+err/100)*(beta(1)+beta(2)*loc);
            min = (1-err/100)*(beta(1)+beta(2)*loc);
            if deltap(i)<max && deltap(i)>min
                bad(i) =  0;
            else
                good(i) = 0;
            end
        end
        disp(locs(29))
        good(good==0) = [];
        bad(bad==0) = [];
    end
    trusted_nums = zeros(length(good));
    for i=1:length(good)
        trusted_nums(i) = meas.measurements{good(i)}.number;
    end
end

save('tokeep.mat','trusted_nums','good') %Saved which points to keep