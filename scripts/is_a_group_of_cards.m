function out_cards = is_a_group_of_cards(source_mask, source_v, source_rgb, raw_mask,  mask)

    average_card_width = 145;
    average_card_height = 226;
    average_card_area = average_card_width*average_card_height;
    w_tolerance = 40;
    h_tolerance = 40;

    box = findbox(source_mask);
    xl = box(1,1);
    xr  = box(1,2);
    ymi = box(1,3);
    yma = box(1,4);

    w = abs(xl - xr);
    h = abs(ymi - yma);
    
    % Calcolo differenza dimensioni rispetto a quelle di una carta
    dif_w = abs(average_card_width - w);
    dif_h = abs(average_card_height - h);

    symbol = ""; 
    cards = {};

    if dif_w >= w_tolerance || dif_h >= h_tolerance % non è una carta 
        
        if(w*h >= average_card_area)
           % imshow(source_v);
            matched_symbol = template_match(source_v);
            if ~strcmp(matched_symbol, "unknown")
                symbol = "gc";
            else
                % Rotazione di 90 gradi dell' immagine per avere almeno 1 carta in
                % verticale e se il template trova un simbolo allora è un
                % gruppo di carte
                matched_symbol = template_match(imrotate(source_v, 90)); 
                if ~strcmp(matched_symbol, "unknown")
                    symbol = "gc";
                end
            end
            
            if strcmp(symbol, "gc")
                cards = recognize_gc(source_rgb, raw_mask, mask);
            else 
                card = DetectedObject(source_mask, source_rgb);
                card.Symbol = "unknown";
                card.Color = "";
                card.MASK = mask;
                
                cards = {card};
            end
        else
            card = DetectedObject(source_mask, source_rgb);
            card.Symbol = "unknown";
            card.Color = "";
            card.MASK = mask;
            
            cards = {card};
        end
    else
        
    end
    
    out_cards = cards;
end

