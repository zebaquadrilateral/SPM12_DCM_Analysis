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
subjects_to_include = [1, 2, 4, 5, 6, 7, 8, 9, 10]; % Example: include only these subjects

% Loop over each subject in the vector
for i = 1:length(subjects_to_include)
    % Get the current subject number
    subj_num = subjects_to_include(i);
    
    % Construct the subject folder name, e.g., 'sub-001', 'sub-002', ..., 'sub-010'
    subj_folder = sprintf('sub-%03d', subj_num);
    
    % Construct the full directory path for the subject
    subj_dir = fullfile(base_dir, subj_folder, '1st_level_new_reduced');
    
    % Loop over each model (1 to 6)
    for model_num = 1:6
        % Construct the DCM model filename, e.g., 'DCM_Model_1.mat', 'DCM_Model_2.mat', etc.
        model_file = fullfile(subj_dir, sprintf('DCM_Model_%d.mat', model_num));
        
        % Check if the file exists
        if exist(model_file, 'file')
            % Load the DCM structure
            load(model_file, 'DCM');
            
            % Estimate the DCM model
            DCM = spm_dcm_estimate(DCM);
            
            % Save the estimated DCM structure back to the same file
            save(model_file, 'DCM');
        else
            fprintf('Model file %s does not exist. Skipping...\n', model_file);
        end
    end
end