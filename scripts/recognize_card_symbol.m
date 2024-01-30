function out_symbol = recognize_card_symbol( ...
    rotated_card_mask, ...
    rotated_rgb_card, ...
    rotated_v_card, ...
    predicted_card_color ...
)

	if is_card(rotated_card_mask, rotated_rgb_card)
		% ESEGUO TEMPLATE MATCH per riconoscere simboli
		% ma escludo le carte girate, riconoscendo se sono carte da gioco o
		% carte girate con la funzione isCard
		value = template_match(rotated_v_card);
		
		% se è cambio colore devo assicurarmi che non sia la carta
		% nulla, quindi con tutti i pixel bianchi nell' ovale
		if strcmpi(value, "cc")
			if is_change_color(predicted_card_color)
				value = "cc";
			else
				value = "empty";
			end
		end
		out_symbol = value;
	else

        card_oval = predicted_card_color;
		card_oval(card_oval ~= 0.8) = 0;
		card_oval(card_oval ~= 0) = 1;
		if is_back_card(card_oval)
			out_symbol = "back";
			
		else
			out_symbol = "unknown";
		end
	end

end

function out  = is_change_color(card)

    %imshow(card);
    %Determino l area dei pixel bianchi rapporto tra zona bianca e sfondo
    card_area = length(card); 
    
    white_pixels_area = sum(card == 1);
    
    perc = white_pixels_area/card_area * 100;
    if perc > 60
        out = false;
    else 
        out = true;
    end
end

function out = is_back_card(oval)
    % dim = size(oval);

    % Determino la dimensione dell ovale coe rapporto tra zona bianca e sfondo
    area = sum(oval(:)); 
    back = sum(oval(:) == 0);
    perc = area/back * 100;
    
    % Considero solo la zona centrale della carta ( tra 80 e 150 px )
    % central = zeros(150-80 + 1, dim(2));
    % central(:,:) = oval(80 : 150, : );

    % subplot(1,2,2), imagesc(labels);
    % booleano per dire se è girata o no
    is_back = false;
    if perc > 20 && perc < 50
        is_back = true;
    end
    out = is_back;

end
