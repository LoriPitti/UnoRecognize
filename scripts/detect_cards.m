function cards = detect_cards()

for i = 2 : object_labeling.size
  %memorizzo indice gruppi di carte
  mask = object_labeling.labels == object_labeling.classes(i); 
  isolated_card_image = extract_card_by_mask(input_image, mask);

  % Estrazione bounding box dalla maschera binaria
  box  = findbox(mask);
  xleft = box(1,1);
  xright  = box(1,2);
  ymin = box(1,3);
  ymax = box(1,4);
  
  width = abs(xleft - xright);
  height = abs(ymax - ymin);

  % Sezione della sola carta nella maschera
  card_mask = zeros(height + 1, width +1);
  card_mask(:,:) = mask(ymin: ymax, xright: xleft );

  % Sezione di carta del canale H dell'immagine
  v_card = zeros(height + 1, width +1);
  v_card(:,:) = v_channel(ymin: ymax, xright: xleft );

  rotated_card_mask = rotate_images(card_mask);
  rotated_v_card = rotate_images(v_card);
  % Creazione immagine di dimensioni esatte dell oggetto/carta per
  % controllare se ha le dimensioni di una carta o meno
  [symbol, cards] = is_a_group_of_cards(rotated_card_mask);

end