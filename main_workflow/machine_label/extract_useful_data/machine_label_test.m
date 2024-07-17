% Do machine label to a single mcd.mat
%
% 2023-10-13, Yixuan Li
%

function label_rearranged = machine_label_test(centerlines_camera, centerlines_lab, timestamps, idx_beyond_edge)

%% init
n_frames = length(timestamps);
label = zeros(n_frames,1);

%% get centerlines
lengths_of_centerlines = get_lengths(centerlines_lab);

%% handle outliers: label NaN as outliers
label = process_nan(label,lengths_of_centerlines);

%% protect beyond edge situation when labelling turn, if you have this info.
if nargin == 4
    mask = label == 0;
    global label_number_beyond_edge
    label(mask) = idx_beyond_edge * label_number_beyond_edge;
end

%% label turn

% round 1, using length of the centerline
label = Tukey_test_of_length_of_centerline(label,lengths_of_centerlines);

% round 2, using Euclidean distance between head and tail
label = Tukey_test_of_distance_between_head_and_tail(label,centerlines_lab);

% round 3, using a_3
label = Tukey_test_of_a_3_test(centerlines_camera, label);

%% end the protection of beyond edge situation
global label_number_beyond_edge
label(label == label_number_beyond_edge) = 0;

%% beta function: Tukey test of phase speed
Tukey_test_of_phase_speed(centerlines_camera,label);

%% label forward and reversal
global frame_window
label = use_phase_trajectory_to_label_forward_and_reversal_test(centerlines_camera,label,frame_window);
label_rearranged = rearrange_label(label);

%% smooth motion states shorter than a frame window 
label_rearranged = smooth_under_frame_window(label_rearranged);

%% process the unlabelled shorter than a time window
label_rearranged = process_the_unlabelled(label_rearranged);

%% label roaming
label_rearranged = label_roaming_test(centerlines_lab,label_rearranged);

%% output figs for human-double-check
global folder_of_saved_files
n_figs = 5;
output_figures(folder_of_saved_files, n_figs);

end