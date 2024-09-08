% Initialize SPM
spm('Defaults', 'fMRI');
spm_jobman('initcfg');

% Define SPM path
spm_path = 'C:\Users\mcnbf\Downloads\spm12\spm12';

% Add paths
addpath(spm_path);

% Define the base directory for all subjects
base_dir = 'C:\Users\mcnbf\Downloads\spm12\spm12\fMRI\TMI\';

% Declare a vector of subject numbers that you want to include
subjects_to_include = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]; % Modify this vector based on the subjects you want to include

% Initialize the batch structure
matlabbatch = {};

for i = 1:length(subjects_to_include)
    % Get the current subject number
    subj_num = subjects_to_include(i);
    
    % Construct the subject folder name, e.g., 'sub-001', 'sub-002', ..., 'sub-010'
    subj_folder = sprintf('sub-%03d', subj_num);
    
    % Construct the full directory path for the subject
    subj_dir = fullfile(base_dir, subj_folder, '1st_level_new_reduced');
    
    % Initialize the cell array to hold the DCM model file paths for this subject
    dcmmat = cell(6, 1);
    
    % Loop over each model (1 to 6) and store the file path in the dcmmat cell array
    for model_num = 1:6
        model_file = fullfile(subj_dir, sprintf('DCM_Model_%d.mat', model_num));
        
        % Add the model file to the list if it exists
        if exist(model_file, 'file')
            dcmmat{model_num} = model_file;
        else
            fprintf('Model file %s does not exist. Skipping...\n', model_file);
        end
    end
    
    % Set up the batch for Bayesian model selection (BMS)
    matlabbatch = []; %Structure intialization
    matlabbatch{i}.spm.dcm.bms.inference.dir = {subj_dir}; % Directory where results will be saved
    matlabbatch{i}.spm.dcm.bms.inference.sess_dcm{1}.dcmmat = dcmmat; % List of DCM models for this subject
    matlabbatch{i}.spm.dcm.bms.inference.model_sp = {''}; % Model space (optional, leave empty)
    matlabbatch{i}.spm.dcm.bms.inference.load_f = {''}; % Load previous BMS results (optional, leave empty)
    matlabbatch{i}.spm.dcm.bms.inference.method = 'FFX'; % Fixed-effects analysis
    matlabbatch{i}.spm.dcm.bms.inference.family_level.family_file = {''}; % Family-level inference (optional, leave empty)
    matlabbatch{i}.spm.dcm.bms.inference.bma.bma_no = 0; % Bayesian Model Averaging (BMA) off
    matlabbatch{i}.spm.dcm.bms.inference.verify_id = 1; % Verify input data IDs
end

% Save the batch to a .mat file (optional)
%save(fullfile(base_dir, 'bms_batch.mat'), 'matlabbatch');

% Run the batch job
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);
