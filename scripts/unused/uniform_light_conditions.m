clear;close all;

raw_image = imread("../dataset/scenes/testing/uno-test-24.jpg");
% Read the image

raw_image = raw_image(230:375, 1190:1410,:);
imshow(raw_image);

ycbcr = rgb2ycbcr(raw_image);
y = ycbcr(:,:,1);

y_correct = homomorphic_filter(y);
y_correct = imadjust(y_correct, [],[], 1/2);

ycbcr(:,:,1) = y_correct;

rgb_correct = ycbcr2rgb(ycbcr);

imshowpair(rgb_correct, raw_image, 'montage')
figure, imshowpair(y, normalize_image(y), 'montage');
 
% Reference - https://blogs.mathworks.com/steve/2013/06/25/homomorphic-filtering-part-1/

function out_image = homomorphic_filter(image)
    
    I = im2double(image);
    
    % Get ln(Image)
    I = log(1 + I);
    
    % Get M, N for FFT
    M = 2*size(I,1) + 1;
    N = 2*size(I,2) + 1;
    
    % Create a centered Gaussian Low Pass Filter
    sigma = 5;
    [X, Y] = meshgrid(1:N,1:M);
    centerX = ceil(N/2);
    centerY = ceil(M/2);
    gaussianNumerator = (X - centerX).^2 + (Y - centerY).^2;
    H = exp(-gaussianNumerator./(2*sigma.^2));
    
    % Create High Pass Filter from Low Pass Filter by 1-H
    H = 1 - H;
    
    % Uncentered HPF
    H = fftshift(H);
    
    % Frequency transform - FFT
    If = fft2(I, M, N);
    
    % High Pass Filtering followed by Inverse FFT
    Iout = real(ifft2(H.*If));
    Iout = Iout(1:size(I,1),1:size(I,2));
    
    % Do exp(I) from log domain
    Ihmf = exp(Iout) - 1;
    
    % display the images
    out_image = im2uint8(Ihmf);
    
end

function [ ii_image ] = RGB2IlluminationInvariant( image, alpha )

%Initialize input (for executing the example):
image = imread('peppers.png');
image = max(image, 1); %Replace zero values with 1, because log(0) is -Inf
image = double(image)/255; %Convert image to double in range [1/255, 1]. In JAVA, you should use double(pix)/255 if pix is a byte in range [0, 255].
alpha = 0.9;

ii_image = 0.5 + log(image(:,:,2)) - alpha*log(image(:,:,3)) - (1-alpha)*log(image(:,:,1));

%Assume elements in JAVA are stored in three 2D arrays (3 planes): R, G, B
%For example: double[][] R = new double[384][512];
%In Matlab 3 planes are:
R = image(:,:,1);
G = image(:,:,2);
B = image(:,:,3);
%II_image = 0.5 + log(G) - alpha*log(B) - (1-alpha)*log(R);
II_image = zeros(size(R));

%Equivalent for loop (simple to implement in JAVA):
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
image_width = size(image, 2);
image_height = size(image, 1);
for y = 1:image_height %Iterate rows, In JAVA: for(y = 0; y < image_height; y++)
    for x = 1:image_width %Iterate columns, In JAVA: for(x = 0; x < image_width; x++)
        r = R(y, x); %In JAVA: double r = R[y][x];
        g = G(y, x);
        b = B(y, x);

        p = 0.5 + log(g) - alpha*log(b) - (1.0-alpha)*log(r);

        II_image(y, x) = p;
    end
end

end

function out_image = normalize_image(image)

% Converti l'immagine in formato double per le operazioni matematiche
immagine = im2double(image);

% Calcola la media e la deviazione standard dell'intera immagine
media = mean(immagine(:));
deviazione_standard = std(immagine(:));

% Normalizza l'immagine in modo che la media sia zero e la deviazione standard sia uno
immagine_normalizzata = (immagine - media) / deviazione_standard;

% Mostra l'immagine originale e l'immagine normalizzata
out_image = im2uint8(immagine_normalizzata);

end