function out = binarization(image)
    
    % Lavoro con canale YCBCR
    im_ycbcr = rgb2ycbcr(image);
    cb = im_ycbcr(:,:,2);
    cr = im_ycbcr(:,:,3);
    
    % Converto anche in HSV
    im_hsv =  rgb2hsv(image);
    v = im_hsv(:, :, 3);
    
    % Eseguo una gamma correction per strechare i chiari per eliminare i
    % riflessi
    gamma = 6;
    v = imadjust(v, [], [], gamma);
    
    % Binarizzo canale v
    v_bw = v > graythresh(v); 
    v_bw = imfill(v_bw, "holes");
    
    % Creo una maschera sogliando tra 2 valori ottenuti con test su CB
    % e riempio con imfill per ottenere maschere delle carte piene
    cb_bw = cb <= 155/255 & cb >= 135/255;
    cb_bw = imfill(cb_bw, "holes");
    
    % Creo maschera sul canale CR
    cr_bw = cr < 125/255;
    cr_bw = imfill(cr_bw, 'holes');
    
    cb_cr_bw = cr_bw & cb_bw;
    cb_cr_bw = imfill(cb_cr_bw, 'holes');
 
    % Combinazione delle due immagine per ottenere la MASCHERA BINARIA FINALE
    final = v_bw | cb_cr_bw;
    
    % Erodo per separare un minimo le carte che si toccano
    %el = strel('square', 5);
    %final = imerode(final, el);
    %figure('WindowStyle', 'docked'), subplot(1,2,1), imshow(img), title('v'),subplot(1,2,2), imshow(final);
    
    % figure(1), imshow(final);


        % Labelling del canale v binarizzato
    labels = uint8(bwlabel(v_bw));
    [n_pixel_per_label, values] = imhist(labels);
    d = size(n_pixel_per_label);
    
    
    % Eliminazione di elementi troppo grossi come quaderno
    % for i = 1 : d(1)
    %     if n_pixel_per_label(i) > 340000
    %         v_bw(v_bw == values(i)) = 0;
    %     end
    % end

    out.bw = final;
    out.spaces.v = v;

    %imshow(final);

end
