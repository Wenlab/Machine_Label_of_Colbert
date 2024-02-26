function human_label = load_human_label(n_frame)

% chose the folder to analyze
root_path = uigetdir;

% if the user choose a folder
if root_path ~= 0

    % get full paths of files
    list = get_all_files_of_a_certain_type_in_a_rootpath(root_path,'*.xlsx');

    % choose files
    [indx,tf] = listdlg('ListString',list,'ListSize',[800,600],...
        'Name','Chose files to convert');

    % if at least 1 file is choosed
    if tf==1
        n_xlsx = length(indx);
        label_all = nan(n_frame,n_xlsx);
        count = 0;
        for i = indx

            count = count + 1;

            % load
            full_path_to_xlsx = list{i};
            data = load_data_from_csv(full_path_to_xlsx);

            % convert
            add_1 = true;
            label_now = xlsx_to_label(data,add_1);

            % cut
            label_all(:,count) = label_now(1:n_frame);
        end

        human_label = create_human_label(label_all);
    end
end

end