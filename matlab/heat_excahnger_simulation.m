clear
clc
close all

%% Heat Exchanger Performance Using NTU Method

m_hot = 1;          
m_cold = 1.2;       

Cp_hot = 4180;      
Cp_cold = 4180;

Th_in = 120;        
Tc_in = 30;        

U = 500;            
A = 10;             

C_hot = m_hot * Cp_hot;
C_cold = m_cold * Cp_cold;

C_min = min(C_hot, C_cold);
C_max = max(C_hot, C_cold);

Cr = C_min / C_max;

NTU=(U*A)/C_min;

effectiveness=(1 - exp(-NTU*(1-Cr))) / (1 - Cr*exp(-NTU*(1-Cr)));

Q=effectiveness * C_min * (Th_in - Tc_in);

Th_out = Th_in - Q/C_hot;
Tc_out = Tc_in + Q/C_cold;

disp(['Heat Transfer Rate (W): ', num2str(Q)])
disp(['Hot Outlet Temp (C): ', num2str(Th_out)])
disp(['Cold Outlet Temp (C): ', num2str(Tc_out)])


%% Temperature Profile Along Heat Exchanger
x = linspace(0,1,100);

Th_profile = Th_in - (Th_in - Th_out)*x;
Tc_profile = Tc_in + (Tc_out - Tc_in)*x;

figure
plot(x,Th_profile,'r','LineWidth',2)
hold on
plot(x,Tc_profile,'b','LineWidth',2)

xlabel('Heat Exchanger Length')
ylabel('Temperature (C)')
title('Temperature Profile Along Heat Exchanger')

legend('Hot Fluid','Cold Fluid')
grid on