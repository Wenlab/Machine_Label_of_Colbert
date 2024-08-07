% Load multiple mcd.mat and perform machine label one by one
%
% 2023-10-13, Yixuan Li
%

% clear
clear;clc;close all;

%
dbstop if error

% chose the folder of files
path = uigetdir;

% if at least 1 file is choosed
if path ~= 0

    % get full paths of files
    list_mcd = get_all_files_of_a_certain_type_in_a_rootpath(path,'*mcd_corrected.mat');

    % choose files
    [indx,tf] = listdlg('ListString',list_mcd,'ListSize',[800,600],'Name','Chose files to convert');

    % if at least 1 file is choosed
    if tf==1
        for i = indx

            % load
            full_path_to_mcd = list_mcd{i};
            mcd = load_mcd(full_path_to_mcd);

            % save folder
            global folder_of_saved_files
            [folder_of_saved_files,save_file_name,~] = fileparts(full_path_to_mcd);
            save_file_name = strrep(save_file_name,'_mcd_corrected','');
            new_folder_name = strcat(save_file_name,'_machine_label');
            folder_of_saved_files = fullfile(folder_of_saved_files, new_folder_name);
            if ~isfolder(folder_of_saved_files)
                mkdir(folder_of_saved_files);
            end

            % extract useful data
            [centerlines_camera, centerlines_lab, timestamps, idx_beyond_edge] = extract_useful_data(mcd);

            % save useful data
            save_folder_path = fullfile(fileparts(folder_of_saved_files),"useful_data");
            create_folder(save_folder_path);
            save_as_mat(save_folder_path, centerlines_camera);
            save_as_mat(save_folder_path, centerlines_lab);
            save_as_mat(save_folder_path, timestamps);
            save_as_mat(save_folder_path, idx_beyond_edge);

            % label head-tail-human-flip
            head_tail_human_flip(centerlines_camera, timestamps);

            % machine label
            label_rearranged = machine_label(centerlines_camera, centerlines_lab, idx_beyond_edge);

            % output
            global frame_window
            file_name = ['machine_label_frame_window_' num2str(frame_window) '.csv'];
            output_label(label_rearranged, folder_of_saved_files, file_name, timestamps);

            % for the taxis project
            integrate_into_reorientation(label_rearranged, timestamps);

            % disp
            disp('Machine Label Finished!');

        end
    end
end

disp('Thanks for using!');
disp('See you next time!');
disp('<<<END>>>');