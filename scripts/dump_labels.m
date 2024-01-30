function out = dump_labels(cards, input_image)

    

	color_labels_definition = load("../ground_truths/color_labels_definition.mat");
	symbol_labels_definition = load("../ground_truths/symbol_labels_definition.mat");

	[height, width, ~] = size(input_image);
	final_color_labels = zeros(height, width, 1);
	final_symbol_labels = zeros(height, width, 1);

	for i=1 : length(cards)
		
		current_card = cards{i};
		card_mask = current_card.MASK;
		
		if(~strcmp(current_card.Color, ""))
			symbol_label_tag = strlabel2pixelid(current_card.Symbol, symbol_labels_definition);
			color_label_tag = strlabel2pixelid(current_card.Color, color_labels_definition);
			
			final_symbol_labels = final_symbol_labels + card_mask .* symbol_label_tag;
			final_color_labels = final_color_labels + card_mask .* color_label_tag;
		end
		
	end

	out.symbol_labels = uint8(final_symbol_labels);
	out.color_labels = uint8(final_color_labels);

end