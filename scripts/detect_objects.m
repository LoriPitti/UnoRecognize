function out = detect_objects(bw)

  % Ciclo tra le labes per selezionare solo le carte singole
  average_card_area = 3.0081e+04; % media dimensione carta intera
  ignore_area_factor = 5;
  not_existing_label = -1;

  labels = bwlabel(bw);
  labels = uint8(labels); % interpreta le label come valori uint8, altrimenti imhist non funziona
  
  [n_pixel_per_label, label_classes] = imhist(labels);
  [n_labels, ~] = size(n_pixel_per_label);

  % Applico una "pulizia" degli array: tolgo gli zeri (labels di sfondo) e
  % tolgo le labels che sono più piccole della dimensione media di una carta
  for i = 1: n_labels
      if n_pixel_per_label(i) == 0
          label_classes(i) = not_existing_label; % Imposta una label che non c'è
      elseif n_pixel_per_label(i) < average_card_area / ignore_area_factor  % Tolgo i riflessi
          n_pixel_per_label(i) = 0;
          label_classes(i) = not_existing_label;
      end
  end

  % Prendo esclusivamente le regioni che hanno più di 0 pixel
  n_pixel_per_label = n_pixel_per_label(n_pixel_per_label ~= 0); % senza find è un'ottimizzazione

  % Prendo esclusivamente le classi che non hanno la label fittizia 
  % (es: classi che hanno area inferiore all'area media di una carta)
  label_classes = label_classes(label_classes ~= not_existing_label);
  
  out.labels = labels;
  out.classes = label_classes;
  out.n_pixels_per_classes = n_pixel_per_label;
  [out.size, ~] = size(label_classes);

end