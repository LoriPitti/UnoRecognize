function out_card_image = extract_card_by_mask(original, mask)

  [height, width, n_channels] = size(original);

  card_image = zeros(height, width, n_channels);
  for i=1:n_channels
    card_image(:,:,i) = mask .* original(:,:,i);
  end

  out_card_image = card_image; 

end