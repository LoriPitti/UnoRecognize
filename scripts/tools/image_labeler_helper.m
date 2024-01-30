labels = load("../../LabellColor/GroundTruthProject/labelDefinitions.mat");

base_img_path = "../../old/dataset/uno-test-";

fig = uifigure('Name', 'Dropdown Example', 'Position', [100, 100, 300, 150]);

% Define dropdown options
dropdownOptions = {'Option 1', 'Option 2', 'Option 3'};

% Create a dropdown (popup menu)
dropdown = uicontrol(fig, 'Style', 'popupmenu', 'String', dropdownOptions, ...
    'Position', [50, 70, 200, 30], 'Callback', @dropdownCallback);

% Create a text label
label = uicontrol(fig, 'Style', 'text', 'Position', [50, 110, 200, 20], 'String', 'Selected Option:');

img_path = base_img_path + 27 + ".jpg";
im = imread(img_path);

ground_truth = zeros(size(im));

bw = binarization(im);

results = detect_objects(bw.bw);

f = figure(2);

%imagesc(results.labels), axis image;

[x, y] = ginput(1);

disp(['Clicked on pixel coordinates: (' num2str(round(x)) ', ' num2str(round(y)) ')']);

% Callback function for the dropdown
function dropdownCallback(src, ~)
    % Get the selected index from the dropdown
    selectedIndex = src.Value;

    % Get the selected option from the dropdownOptions
    selectedOption = dropdownOptions{selectedIndex};

    % Update the text label
    label.String = ['Selected Option: ' selectedOption];
end


