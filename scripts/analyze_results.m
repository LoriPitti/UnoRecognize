clear; close all;

dataset_path = "../dataset/scenes/testing/";
color_ground_truths_path = "../ground_truths/color/gt-c-uno-test-%s.png";
symbol_ground_truths_path = "../ground_truths/symbol/gt-s-uno-test-%s.png";
color_labels_definition = load("../ground_truths/color_labels_definition.mat");
symbol_labels_definition = load("../ground_truths/symbol_labels_definition.mat");
dump_color_charts_folder = "../results_analysis/confmat/color/uno-test-%s.png";
dump_symbol_charts_folder = "../results_analysis/confmat/symbol/uno-test-%s.png";

total_true_positives_color = 0;
total_samples_color = 0;

total_true_positives_symbol = 0;
total_samples_symbol = 0;

images_list = dir(dataset_path);

for i = 1:length(images_list)
    disp(images_list(i));
    if ~images_list(i).isdir
        image_filename = images_list(i).name;
        image_number = image_filename(10:11);

        % GT da file. String formatting per ottenere il filename corretto
        color_gt = imread(sprintf(color_ground_truths_path, image_number));
        symbol_gt = imread(sprintf(symbol_ground_truths_path, image_number));

        image = imread(dataset_path + image_filename);

        [classified_labels, classified_cards ] = cards_pipeline(image);

        % show_result(image, classified_cards);

        color_confmat = confusionmat(classified_labels.color_labels(:), color_gt(:));
        symbol_confmat = confusionmat(classified_labels.symbol_labels(:), symbol_gt(:));

        color_confmat_classes = get_used_classes(color_gt, classified_labels.color_labels, color_labels_definition);
        symbol_confmat_classes = get_used_classes(symbol_gt, classified_labels.symbol_labels, symbol_labels_definition);

        plot_confchart( ...
            color_confmat, ...
            color_confmat_classes, ...
            image_filename(1:11), ...
            image_number, ...
            dump_color_charts_folder ...
        );

        plot_confchart( ...
            symbol_confmat, ...
            symbol_confmat_classes, ...
            image_filename(1:11), ...
            image_number, ...
            dump_symbol_charts_folder ...
        );

        % Aggiornamento delle statistiche cumulative
        total_true_positives_color = total_true_positives_color + sum(diag(color_confmat));
        total_samples_color = total_samples_color + numel(color_gt(:));

        total_true_positives_symbol = total_true_positives_symbol + sum(diag(symbol_confmat));
        total_samples_symbol = total_samples_symbol + numel(symbol_gt(:));
      
    end
end

% Calcolo delle percentuali medie
average_accuracy_color = total_true_positives_color / total_samples_color;
average_accuracy_symbol = total_true_positives_symbol / total_samples_symbol;

disp("Average Accuracy for Colors: " + 100 * average_accuracy_color + "%");
disp("Average Accuracy for Symbols: " + 100 * average_accuracy_symbol + "%");


function out_used_classes = get_used_classes(gt, predicted, labels_definition)
    [gt_pixel_id_classes, ~] = imhist(gt);
    [predicted_pixel_id_classes, ~] = imhist(predicted);

    used_gt_labels = find(gt_pixel_id_classes ~= 0) -1;
    used_predicted_labels = find(predicted_pixel_id_classes ~= 0) -1;

    used_labels_classes = "background";
    for i=2 : size(used_gt_labels)
        index = cellfun(@(x) isequal(x, used_gt_labels(i)), labels_definition.S.PixelLabelID);
        used_labels_classes{i} = labels_definition.S.Name{index};
    end

    for i=2 : size(used_predicted_labels)
        index = cellfun(@(x) isequal(x, used_predicted_labels(i)), labels_definition.S.PixelLabelID);
        label_name = labels_definition.S.Name{index};
        if isempty(find(strcmp(used_labels_classes, label_name), 1))
            used_labels_classes{end + 1} = label_name;
        end
    end

    
    out_used_classes = categorical(used_labels_classes);

end

function plot_confchart(confmat, classes, img_name, img_number, save_path)
        
    figure('Renderer', 'painters', 'Position', [0 0 1920 1080]);
    confchart = confusionchart( ...
    confmat, ...
    classes, ...
    'DiagonalColor', "#D2292C", ...
    'OffDiagonalColor', "#000000", ...
    'XLabel', "Classificate", ...
    'YLabel', "Ground Truth", ...
    'RowSummary','row-normalized',...
    'ColumnSummary','column-normalized' ...
    );
    title(img_name);
    sortClasses(confchart, "descending-diagonal");
    saveas(confchart, sprintf(save_path, img_number));
    close(gcf);
end