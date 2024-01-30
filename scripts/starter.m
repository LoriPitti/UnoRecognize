clc, close all, clear;
img = imread("..\dataset\scenes\training\uno-test-17.jpg");

[classification_labels, classified_cards] = cards_pipeline(img);

figure(1), show_result(img, classified_cards);

%subplot(2,1,2), imagesc(classification_labels.color_labels), axis image;