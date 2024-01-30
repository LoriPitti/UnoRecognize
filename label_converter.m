clear;
close all;

card = "uno-test-30";

original = "../old/dataset/";
path_gt = "../ground-truths/colore/gt-c-";

original = imread(original + card + ".jpg");
color_gt = imread(path_gt + card + ".png");

[labels, n_regions] = show_labels_and_original(original, color_gt);

convert(card, labels, n_regions);

function convert(card, labels, n_regions)
    mapping = [5,8,11,1,4,7,9,8,10,10,3,2,11,5,11,14,6,10];
    
    [rows, cols] = size(labels);
    out_labels = zeros(rows, cols);

    for i=1:n_regions
        out_labels(labels == i) = mapping(i);
    end
    
    imwrite(uint8(out_labels), "gt-s-" + card + ".png");
end

function [out_labels, out_n_regions] = show_labels_and_original(original, color_gt)

    % figure, imagesc(color_gt), axis image;
    
    bw = color_gt ~= 0;
    
    [labels, n_regions] = bwlabel(bw);
    
    figure; 
    subplot(2,1,1), imshow(original);
    subplot(2,1,2), imagesc(labels), axis image;
    
    for i = 1:n_regions
        
        [rows, cols] = find(labels == i);
        
        % Calcola il centroide della regione
        centroid = round([mean(cols), mean(rows)]);
        
        % Visualizza l'etichetta e il numero associato all'interno della regione
        text(centroid(1), centroid(2), num2str(i), 'Color', 'r', 'FontSize', 10, 'FontWeight', 'bold');
    end
    
    bounding_boxs = regionprops(labels, 'BoundingBox');
    hold on;
    for i = 1:n_regions
        rectangle('Position', bounding_boxs(i).BoundingBox, 'EdgeColor', 'g', 'LineWidth', 2);
    end
    hold off;

    out_labels = labels;
    out_n_regions = n_regions;

end

