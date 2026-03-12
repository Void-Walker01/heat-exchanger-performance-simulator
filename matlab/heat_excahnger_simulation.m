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


%% LMTD Method

deltaT1=Th_in - Tc_out;
deltaT2=Th_out - Tc_in;

LMTD=(deltaT1 - deltaT2) / log(deltaT1/deltaT2);

Q_LMTD=U*A*LMTD;

disp(['LMTD (C): ', num2str(LMTD)])
disp(['Heat Transfer Rate using LMTD (W): ', num2str(Q_LMTD)])


%% Effect of hot fluid flow rate on heat transfer

m_hot_values = linspace(0.5,3,20);
Q_values = zeros(size(m_hot_values));

for i = 1:length(m_hot_values)
    m_hot_test = m_hot_values(i);

    C_hot_test = m_hot_test * Cp_hot;
    C_min_test = min(C_hot_test, C_cold);
    C_max_test = max(C_hot_test, C_cold);

    Cr_test = C_min_test / C_max_test;

    NTU_test = (U*A)/C_min_test;

    effectiveness_test = (1 - exp(-NTU_test*(1-Cr_test))) / (1 - Cr_test*exp(-NTU_test*(1-Cr_test)));

    Q_values(i) = effectiveness_test * C_min_test * (Th_in - Tc_in);
end

figure
plot(m_hot_values,Q_values,'o-','LineWidth',2)

xlabel('Hot Fluid Mass Flow Rate (kg/s)')
ylabel('Heat Transfer Rate (W)')
title('Effect of Hot Fluid Flow Rate on Heat Transfer')

grid on



%% Effect of heat transfer coefficient on heat transfer

U_values = linspace(200,800,20);
Q_U = zeros(size(U_values));

for i = 1:length(U_values)

    U_test = U_values(i);

    NTU_test = (U_test*A)/C_min;

    eff_test = (1 - exp(-NTU_test*(1-Cr))) / (1 - Cr*exp(-NTU_test*(1-Cr)));

    Q_U(i) = eff_test * C_min * (Th_in - Tc_in);

end

figure
plot(U_values,Q_U,'LineWidth',2)

xlabel('Overall Heat Transfer Coefficient (W/m^2K)')
ylabel('Heat Transfer Rate (W)')
title('Effect of Heat Transfer Coefficient on Heat Transfer')
grid on



%% Effect of fouling factor on heat transfer

Rf_values = linspace(0,0.001,20);
Q_fouling = zeros(size(Rf_values));

for i = 1:length(Rf_values)

    Rf = Rf_values(i);

    U_f = 1/(1/U + Rf);

    NTU_test = (U_f*A)/C_min;

    eff_test = (1 - exp(-NTU_test*(1-Cr))) / (1 - Cr*exp(-NTU_test*(1-Cr)));

    Q_fouling(i) = eff_test * C_min * (Th_in - Tc_in);

end

figure
plot(Rf_values,Q_fouling,'LineWidth',2)

xlabel('Fouling Resistance (m^2K/W)')
ylabel('Heat Transfer Rate (W)')
title('Effect of Fouling Factor on Heat Transfer')
grid on