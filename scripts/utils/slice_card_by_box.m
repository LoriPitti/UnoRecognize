function out_card_image =slice_card_by_box(original, mask)

   [height, width, n_channels] = size(original);
   card_image = zeros(height, width, n_channels);

   box  = findbox(mask);
   xleft = box(1,1);
   xright  = box(1,2);
   ymin = box(1,3);
   ymax = box(1,4);

   width = abs(xleft - xright);
   height = abs(ymax - ymin);
   
   out_card_image = zeros(height +1 , width +1, n_channels);
   for i=1:n_channels
      card_image(:,:,i) = mask .* original(:,:,i);
      out_card_image(:,:,i) = card_image(ymin: ymax, xright: xleft, i);
   end
end