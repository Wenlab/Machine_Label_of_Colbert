% Load multiple mcd.mat and perform machine label one by one
%
% 2023-10-13, Yixuan Li
%

% clear
clear;clc;close all;

% chose the folder of files
path = uigetdir;

% if at least 1 file is choosed
if path ~= 0

    % get full paths of files
    list = get_all_folders_of_a_certain_name_pattern_in_a_rootpath(path,'useful_data');

    % choose files
    [indx,tf] = listdlg('ListString',list,'ListSize',[800,600],'Name','Chose files to convert');

    % if at least 1 file is choosed
    if tf==1
        for i = indx

            % data folder
            folder_path = list{i};

            % result folder
            global folder_of_saved_files
            [folder_of_saved_files,~,~] = fileparts(folder_path);
            folder_of_saved_files = fullfile(folder_of_saved_files, "machine_label_via_centerlines");
            if ~isfolder(folder_of_saved_files)
                mkdir(folder_of_saved_files);
            end

            % load
            try
                centerlines_camera = load_data_from_mat(fullfile(folder_path,"centerlines_camera.mat"));
            catch
                disp("No centerlines_camera.mat.");
                centerlines_camera = [];
            end

            centerlines_lab = load_data_from_mat(fullfile(folder_path,"centerlines_lab.mat"));

            try
                timestamps = load_data_from_mat(fullfile(folder_path,"timestamps.mat"));
            catch
                disp("No timestamps.mat.");
                timestamps = -1;
            end

            try
                idx_beyond_edge = load_data_from_mat(fullfile(folder_path,"idx_beyond_edge.mat"));
            catch
                disp("No idx_beyond_edge.mat.");
                idx_beyond_edge = false;
            end

            % generate fake camera coordinates
            if isempty(centerlines_camera)
                centerlines_camera = generate_fake_camera_coordinates(centerlines_lab);
            end            

            % machine label
            label_rearranged = machine_label(centerlines_camera, centerlines_lab, idx_beyond_edge);

            % output
            global frame_window
            file_name = ['machine_label_frame_window_' num2str(frame_window) '.csv'];
            output_label(label_rearranged, folder_of_saved_files, file_name, timestamps);

            % for the taxis project
            % integrate_into_reorientation(label_rearranged, timestamps);

            % disp
            disp('Machine Label Finished!');
        end
    end
end

disp('Thanks for using!');
disp('See you next time!');
disp('<<<END>>>');