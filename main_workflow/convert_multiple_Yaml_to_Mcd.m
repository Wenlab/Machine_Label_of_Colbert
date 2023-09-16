% Convert multiple .yaml to mcd.mat at 1 time

clear;clc;close all;

% add path
my_add_path

% chose the folder to analyze
path = uigetdir;

% if the user choose a folder
if path ~= 0

    % get full paths of files
    list = get_all_files_of_a_certain_type_in_a_rootpath(path,'*.yaml');
    
    % choose files
    [indx,tf] = listdlg('ListString',list,'ListSize',[800,600],...
            'Name','Chose files to convert');
    
    % if at least 1 file is choosed
    if tf==1
        for i = indx
            full_path_to_yaml = list{i};
            mcd = Mcd_Frame;
            mcd = mcd.yaml2matlab(full_path_to_yaml); % most time-consuming step
            folder_of_saved_mcd = fileparts(full_path_to_yaml);
            savepath = fullfile(folder_of_saved_mcd, 'mcd.mat');
            save(savepath, 'mcd');
            disp('mcd file saved successfully!');
        end
    end
end

disp('<<<END>>>');