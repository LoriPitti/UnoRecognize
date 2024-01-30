red = im2double(imread('../../dataset/colors/red.png'));
green = im2double(imread('../../dataset/colors/green.png'));
blue =  im2double(imread('../../dataset/colors/blue.png'));
yellow = im2double(imread('../../dataset/colors/yellow.png'));
other = im2double(imread('../../dataset/colors/other.png'));
black = im2double(imread('../../dataset/colors/black.png'));

% Prendo dimensioni img
[rows, cols, ch1] = size(red);
[rows2, cols2, ch2] = size(green);
[rows3, cols3, ch3] = size(yellow);
[rows4, cols4, ch4] = size(blue);
[rows5, cols5, ch5] = size(other);
[rows7, cols7, ch7] = size(black);

% Ridimensiono in ARRAY LINEARE le immagini
red = reshape(red, rows * cols, ch1);
green = reshape(green, rows2 * cols2, ch2);
yellow = reshape(yellow, rows3 * cols3, ch3);
blue = reshape(blue, rows4 * cols4, ch4);
other = reshape(other, rows5 * cols5, ch5);
black = reshape(black, rows7 * cols7, ch7);

nvalues = round(3200/3); %pixel da prendere per img
train_values = [other(1:nvalues, :); green(1:nvalues, :);yellow(1:nvalues, :); blue(1:nvalues, :); red(1:nvalues, :); black(1: nvalues, :)];
%0 = nero
%0.8 = rosso
%02 = verde
%04 = giallo
%06 = blu
%1 = altro
train_labels = [ones(nvalues,1); ones(nvalues, 1)*0.2; ones(nvalues, 1)*0.4; ones(nvalues, 1)*0.6; ones(nvalues, 1)*0.8; zeros(nvalues, 1)];

%addrestro il classificatore
c = fitcnb(train_values, train_labels);

save("color_classifier_model", "c");