function [out_labels, out_cards] = cards_pipeline(image)
    addpath(genpath(pwd));
	input_image = im2double(image);

	binarization_results = binarization(input_image);
	v_channel = binarization_results.spaces.v;
	bw_mask = binarization_results.bw;

	object_labels = detect_objects(bw_mask);

	cards = recognize_objects(input_image, v_channel, object_labels);
	
	cards_classified = {};

	for i = 1:length(cards)
		current_card = cards{i};
		
		if (strcmp(current_card.Symbol, "undefined"))
			[rotated_rgb_card, rotated_card_mask] = rotate_images(current_card.RGB, current_card.BW);
			
			rotated_v_card = rgb2hsv(rotated_rgb_card);
			rotated_v_card = rotated_v_card(:,:,3);
			

			[card_color, predicted_card_color] = classify_card_color(rotated_rgb_card, rotated_card_mask);
			current_card.Color = card_color;
			
			card_symbol = recognize_card_symbol(rotated_card_mask, rotated_rgb_card, rotated_v_card, predicted_card_color);
			current_card.Symbol = card_symbol;
			if(strcmp(card_symbol, "back") || strcmp(card_symbol, "unknow"))
				current_card.Color = "";
			end

		end
		cards_classified{length(cards_classified)+1} = current_card;
	end

	labels = dump_labels(cards_classified, input_image);
	
	out_labels = labels;
	out_cards = cards_classified;
	%show_result(input_image,cards_classified);
end