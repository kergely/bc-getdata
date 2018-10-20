%> @file Hidsima.m
%> @brief A file for describing the hidraulically even surface
%=============================
%> @brief A function for calcualting the loss factor in a hydraullyical eve nsurface.

function [lambda] = Hidsima(Re)
lambda0 = 0.02;
alpha = sqrt(lambda0);
epsilon = 1.0; %The error

%Newton módszerrel történő megoldás

while epsilon>0.00005
    f = 1.95*log10(Re*alpha)-0.55-1/alpha;
    fdot = (1.95/log(10))*(1/alpha)+1/alpha^2; %Kézzel lederiválva
    alpha_new = alpha-(f/fdot);
    epsilon = (alpha_new-alpha)/alpha;
    alpha = alpha_new;
end
lambda = alpha^2.0+0.004;
end
