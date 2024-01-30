function out_cards = recognize_objects(input_image, v_channel, object_labels)
    
    cards = {};
    for i = 2 : object_labels.size
        % Memorizzo indice gruppi di carte
        mask = object_labels.labels == object_labels.classes(i); 
        
        masked_rgb_card = extract_card_by_mask(input_image, mask);
        rgb_card = slice_card_by_box(masked_rgb_card, mask);
    
        % Sezione della sola carta nella maschera
        card_mask= slice_card_by_box(mask, mask);
    
        % Sezione di carta del canale V dell'immagine
        v_card = slice_card_by_box(v_channel, mask);
    
        rotated_card_mask = rotate_images(card_mask);
        rotated_v_card = rotate_images(v_card, card_mask);
        % Creazione immagine di dimensioni esatte dell oggetto/carta per
        % controllare se ha le dimensioni di una carta o meno
        cards_of_gc = is_a_group_of_cards( ...
            rotated_card_mask, ...
            rotated_v_card, ...
            rgb_card, ...
            card_mask, ...
            mask ...
        );
        
       %se è vuoto vuol dire che non è stato trovato un gruppo di
       %carte/estraneo ma una carta 
        if isempty(cards_of_gc)
            card = DetectedObject(card_mask, rgb_card);
            card.Symbol = "undefined";
            card.MASK = mask;
            card.V = v_card;
            cards{length(cards) + 1} = card;
        else
            cards = [cards, cards_of_gc];
        end


    end

    out_cards = cards;
end