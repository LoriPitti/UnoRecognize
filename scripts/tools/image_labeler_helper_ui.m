close all; 
clear;

main()

function main

    labels_path = "Nessun file selezionato";
    labels = [];

    ui = figure("Name", "Image labeler helper");
    
    labels_row_layout = uiflowcontainer(ui, 'FlowDirection', 'lefttoright');
    
    uicontrol(labels_row_layout, 'Style', 'pushbutton', ...
        'String', "Seleziona il file LabelDefinitions.mat", ...
        'Callback', @get_file, ...
        'Position', [10, 10, 200, 40] ...
    );

    labels_path_txt = uicontrol(labels_row_layout, 'Style', 'text', ...
        'String', labels_path, ...
        'Position', [10, 30, 200, 40], ...
        'HorizontalAlignment', 'left' ...
    );
    
    function get_file(~,~)
    
        [file_name, file_path] = uigetfile("*.mat", 'Seleziona il file LabelDefinitions.mat');
        
        if ~isequal(file_name, 0) && ~isequal(file_path, 0)
            labels_path = fullfile(file_path, file_name);
            labels = load(labels_path);
    
            set(labels_path_txt, 'String', labels_path);
            drawnow;
        end
    end

end