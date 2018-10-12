clear variables;
%Geometric description of the measuring apparatus
A_small = 150e-3*150e-3; %[m^2]
A_big = 250e-3*250e-3; %[m^2]
D_big = 4*A_big/(4*250e-3); %[m]
D_small = 4*A_small/(4*150e-3); %[m]
L_step = 50e-3; %[m]
dist_BC = 7.9250; %[[m] - Borda-Carnot location
%Borda-Carnot between 401 and 329
small_end = 40; %Small tube end
%inflow measurement settings
epsilon = 1.0; % [-]
alpha = 0.598; %[-]
D_be = 0.12; %[m]
%Gas (air) constants
R = 287;% [J/KgK]
nu = 14.88e-6; % [m^2/s]
rho = 1.2; % [kg/m^3]
save('constants.mat')