function [lambda] = Hidsima(Re)
%UNTITLED Summary of this function goes here
%   Ez sem lesz jó, nincs akkora szerencsénk persze
lambda0 = 0.02;
alpha = sqrt(lambda0);
epsilon = 1.0; %The error

%Nweton módszerrel történő megoldás

while epsilon>0.00005
    f = 1.95*log10(Re*alpha)-0.55-1/alpha;
    fdot = (1.95/log(10))*(1/alpha)+1/alpha^2; %Kézzel lederiválva
    alpha_new = alpha-(f/fdot);
    epsilon = (alpha_new-alpha)/alpha;
    alpha = alpha_new;
end
lambda = alpha^2.0;
end

