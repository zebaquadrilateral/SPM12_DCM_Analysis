% Initialize SPM
spm('Defaults', 'fMRI');
spm_jobman('initcfg');

% Define base paths
root = 'C:\Users\mcnbf\Downloads\spm12\spm12\fMRI\TMI';
spm_path = 'C:\Users\mcnbf\Downloads\spm12\spm12';
data_folder_path = fullfile(root);

% Add paths
addpath(spm_path);
addpath(root);

% Specify data, participant, and run paths
subject_folder = {'sub-001'};  % Define your subject folders here

% Define models with specific matrices
%The matrices columns represent source region and the rows represent the target region
% Matrix A defines the on/off Endogenous Connections, here all the diagonal
% elements being one means that self inhibitory connections like e.g. from rBA2 to rBA2 are included 
% Matrix B defines the modulatory connections for the two connections: 
% Stimulus Perception: B(:,:,1)and Imagery B(:,:,2)
% Matrix C defines Driving Inputs at specified regions for the two conditions:
% Stimulus Perception and Imagery (in that order)
models = { 
    struct('A', [1 0 0; 1 1 0; 1 0 1], 'B', cat(3, [0 0 0; 1 0 0; 1 0 0], [0 0 0; 0 0 0; 0 0 0]), 'C', [1 0; 0 1; 0 1]), % Model 1
    struct('A', [1 1 1; 0 1 0; 0 0 1], 'B', cat(3, [0 1 1; 0 0 0; 0 0 0], [0 0 0; 0 0 0; 0 0 0]), 'C', [0 1; 1 0; 1 0]), % Model 2
    struct('A', [1 0 0; 1 1 0; 1 0 1], 'B', cat(3, [0 0 0; 0 0 0; 0 0 0], [0 0 0; 1 0 0; 1 0 0]), 'C', [0 1; 1 0; 1 0]), % Model 3
    struct('A', [1 1 1; 0 1 0; 0 0 1], 'B', cat(3, [0 0 0; 0 0 0; 0 0 0], [0 1 1; 0 0 0; 0 0 0]), 'C', [1 0; 0 1; 0 1]), % Model 4
    struct('A', [1 1 1; 1 1 0; 1 0 1], 'B', cat(3, [0 0 0; 1 0 0; 1 0 0], [0 1 1; 0 0 0; 0 0 0]), 'C', [1 0; 0 1; 0 1]), % Model 5 (Full Model)
    struct('A', [1 1 1; 1 1 0; 1 0 1], 'B', cat(3, [0 1 1; 0 0 0; 0 0 0], [0 0 0; 1 0 0; 1 0 0]), 'C', [0 1; 1 0; 1 0])  % Model 6
};

% Loop through each subject
for j = 1:numel(subject_folder)
    
    sub_path_folder = fullfile(data_folder_path, subject_folder{j}, '1st_level_new_reduced');
    file_path_SPMmat = fullfile(sub_path_folder, 'SPM.mat');
    load(file_path_SPMmat);
   
    % Define paths for DCM and VOI folders
    DCM_folder_path = fullfile(sub_path_folder, 'DCM');
    if ~exist(DCM_folder_path, 'dir')
        mkdir(DCM_folder_path);
    else
        disp('DCM folder already exists.');
    end
    
    % Load regions of interest
    %--------------------------------------------------------------------------
    load(fullfile(sub_path_folder, 'VOI_rBA2_1.mat'), 'xY');
    DCM.xY(1) = xY;
    load(fullfile(sub_path_folder, 'VOI_rSII_1.mat'), 'xY');
    DCM.xY(2) = xY;
    load(fullfile(sub_path_folder, 'VOI_SMA_1.mat'), 'xY');
    DCM.xY(3) = xY;
    
    DCM.n = length(DCM.xY);      % number of regions
    DCM.v = length(DCM.xY(1).u); % number of time points
    
    % Time series
    %--------------------------------------------------------------------------
    DCM.Y.dt  = SPM.xY.RT;  % Use TR from SPM (Repetition Time)
    DCM.Y.X0  = DCM.xY(1).X0;
    for i = 1:DCM.n
        DCM.Y.y(:,i)  = DCM.xY(i).u;
        DCM.Y.name{i} = DCM.xY(i).name;
    end
    
    DCM.Y.Q = spm_Ce(ones(1, DCM.n) * DCM.v);
    
    % Experimental inputs
    %--------------------------------------------------------------------------
    DCM.U.name = {'Stimulation', 'Imagery'}; % Input names

    % If there is only one session, concatenate its conditions
    DCM.U.u = SPM.Sess(1).U(1).u;  % First condition
    if numel(SPM.Sess(1).U) > 1
        DCM.U.u = [DCM.U.u, SPM.Sess(1).U(2).u];  % Concatenate second condition if it exists
    end
    
    % DCM parameters and options
    %--------------------------------------------------------------------------
    DCM.delays = repmat(1, DCM.n, 1);  % Same delay for all regions
    DCM.TE = 0.03;  % Define TE (30 ms)
    
    DCM.options.nonlinear  = 0;  % Bilinear modulation
    DCM.options.two_state  = 0;  % One-state
    DCM.options.stochastic = 0;  % No stochastic effects
    DCM.options.centre     = 1;  % Mean-centering (time series)
    DCM.options.induced    = 0;
    
    % Loop through each model and save the DCM structure
    for m = 1:length(models)
        DCM.a = models{m}.A;
        DCM.b = models{m}.B;
        DCM.c = models{m}.C;
        
        % Specify the model
        DCM.name = sprintf('DCM_model_%d.mat', m);
        save(fullfile(DCM_folder_path, DCM.name), 'DCM');
        
        % Model specification function (if further processing is required)
        % You can add any additional steps needed for specification here
        matlabbatch{1}.spm.dcm.fmri.specify.dcmfile = {fullfile(DCM_folder_path, DCM.name)};
        
        % Save the batch file (optional)
        batch_file_name = fullfile(DCM_folder_path, sprintf('batch_specify_model_%d.mat', m));
        save(batch_file_name, 'matlabbatch');
        
        % Clear matlabbatch for the next model
        clear matlabbatch;
    end
end
