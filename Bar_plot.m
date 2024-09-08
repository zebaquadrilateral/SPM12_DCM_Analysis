
addpath(pwd) %add the path of the dcm file
load("DCM_Model_5.mat") %add the name of the DCM file 
DCM.Vp % loading the Vp data from the DCM structure 
DCM.Vp.A 
DCM.Vp.C
DCM.Vp.B
%Cp_re=spm_unvec(diag(DCM.Cp),DCM.Ep) %takes the variances of the posterior parameter estimates (extracted from the diagonal of the covariance matrix DCM.Cp) and reshapes them into a structure that matches the model parameters in DCM.Ep
Ep_Values_A = [Ep.A(2,1),Ep.A(3,1),Ep.A(1,2),Ep.A(1,3)]; %Posterior parameter estimates (means) of Fixed Connection : matrix A 
Vp_Values_A = [DCM.Vp.A(2,1),DCM.Vp.A(3,1),DCM.Vp.A(1,2),DCM.Vp.A(1,3)]; %Posterior parameter variance of Fixed Connection : matrix A 
%Cp_Values_A = [Cp_re.A(2,1),Cp_re.A(3,1),Cp_re.A(1,2),Cp_re.A(1,3)]; %%Posterior parameter covariance  of Fixed Connection : matrix A 
names_A = {'A:rBA2 → rS2', 'A:rBA2 → SMA','A:rS2→rBA2','A:rS2→rBA2'}; %Names of the corresponding connections
%num_A = {'1', '2','3', '4'} %numbers corresponding to connection names
% Modulatory connections (Stimulus Perception)
Ep_Values_B = [Ep.B(2,1,1),Ep.B(3,1,1),Ep.B(1,2,2),Ep.B(1,3,2)]; %Posterior parameter estimates (means) of Modulatory Connection : matrix B
Vp_Values_B = [DCM.Vp.B(2,1,1),DCM.Vp.B(3,1,1),DCM.Vp.B(1,2,2),Ep.B(1,3,2)]; %Posterior parameter variance of Modulatory Connection : matrix B
%Cp_Values_B =[Cp_re.B(2,1,1),Cp_re.B(3,1,1),Cp_re.B(1,2,2),Cp_re.B(1,3,2)]; %Posterior parameter covariance  of Fixed Connection : matrix B
names_B = {'B:rBA2 → rS2 (Stim)', 'B:rBA2 → SMA (Stim)','B:rS2→rBA2(Imag)','B:rS2→rBA2(Imag)'}; %%Names of the corresponding connections
%names_B = {'5', '6','7','8'}; %numbers corresponding to connection names
% Driving inputs (Stimulus Perception at rBA2, Imagery at rS2 and SMA)
Ep_Values_C = [Ep.C(1,1),Ep.C(2,2),Ep.C(3,2)]; %%Posterior parameter estimates (means) of Driving Inputs : matrix C
Vp_Values_C = [DCM.Vp.C(1,1),DCM.Vp.C(2,2),DCM.Vp.C(3,2)]; %%Posterior parameter variance of Driving Inputs : matrix C
%Cp_Values_C = [Cp_re.C(1,1),Cp_re.C(2,2),Cp_re.C(3,2)]; %%Posterior parameter covariance  of Driving Inputs : matrix C
names_C = {'C:Stim → rBA2', 'C:Imagery → rS2', 'C:Imagery → SMA'}; %%Names of the corresponding connections
%names_C = {'9', '10', '11'};
% Combine all values and names
Ep_Values = [Ep_Values_A, Ep_Values_B, Ep_Values_C];
Vp_Values = [Vp_Values_A, Vp_Values_B, Vp_Values_C];
%Cp_Values = [Cp_Values_A, Cp_Values_B, Cp_Values_C];
names = [names_A, names_B, names_C];

% Confidence intervals
ci = sqrt(Vp_Values); % Taking square root of variance to get standard deviation

% Plot
figure;

% Plot bar graph with no gap between bars (using 'BarWidth')
bar(Ep_Values, 'BarWidth', 1); 

hold on;

% Plot error bars with pink color and increased thickness
errorbar(1:length(Ep_Values), Ep_Values, ci, '.k', 'LineWidth', 1, 'Color', [1 0.4 0.6]); 

hold off;

% Set the x-ticks and labels
set(gca, 'XTick', 1:length(Ep_Values), 'XTickLabel', names, 'XTickLabelRotation', 45, 'FontSize', 10);

% Label y-axis and set title
ylabel('Posterior Estimates');
xlabel('Connections');
title('Optimized (Reduced) Model 5');
grid on;