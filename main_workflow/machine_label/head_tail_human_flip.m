% Find the frame of head-tail-human-flip, then output them in a .csv file.
%
% 2023-10-13, Yixuan Li
%

function head_tail_human_flip(centerlines_camera, timestamps)

% handle outliers: label NaN as outliers
lengths_of_centerlines = get_lengths(centerlines_camera);
n_frames = length(centerlines_camera);
label = zeros(n_frames, 1);
label = process_nan(label,lengths_of_centerlines);

% get centerline before unit conversion
global label_number_human_flip

mask = label == 0; % only label the unlabelled
label_flip_temp = zeros(sum(mask),1);
centerlines_camera = centerlines_camera(mask);

for i = 2:numel(label_flip_temp)-1
    
    head_x = centerlines_camera{i,1}(1,1);
    head_y = centerlines_camera{i,1}(2,1);
    tail_next_x = centerlines_camera{i+1,1}(1,100);
    tail_next_y = centerlines_camera{i+1,1}(2,100);
    pixel_threshold = 5; % a super-parameter
    
    % if the below the threshold
    if abs(head_x - tail_next_x) <= pixel_threshold && abs(head_y - tail_next_y) <= pixel_threshold
        
        % should label i+1 and i, but virtual Dub starts from frame 0, so I label i-1 and i here.
        label_flip_temp(i - 1) = label_number_human_flip; 
        label_flip_temp(i) = label_number_human_flip;
        
    end
    
end

label_flip = zeros(n_frames,1);
label_flip(mask) = label_flip_temp;
label_flip = rearrange_label(label_flip);
label_flip = remain_rows(label_flip,label_number_human_flip);

% save
global folder_of_saved_files
file_name = 'head_tail_human_flip.csv';
output_label(label_flip, folder_of_saved_files, file_name, timestamps)

end