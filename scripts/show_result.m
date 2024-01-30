    %stamoa a schermo le bbxo delle carte con il rispettivo nome
    %stamoa a schermo le bbxo delle carte con il rispettivo nome
function show_result(img, cards)
    
    box_matrix = []; %matrice di bounding box
    box_label = [];
    position = [];%matrice di posizone per cfruppi di carte
    box_color = []; %colore delle labels
    font_color = []; % colori del testo
    figure(1), imshow(img);

    %primo ciclo per stampare carte nonrmali
    for i = 1 : length(cards)
        current_card = cards{i};
       
        if strcmp(current_card.Symbol,  "gc") % se è gruppo di carte etichetta in un altro modo
            continue;
        end
        value =  current_card.Symbol;
        color = current_card.Color;
        color2 = color;
        if strcmp(color, "other") || strcmp(color, "")
            color = "black";
            color2 = "";
        end
        mask = current_card.MASK;

       %compongo la sarray string con le etichette delle labels
        box_matrix  = create_box2(box_matrix, mask);
        box_label = [box_label , value + " " + color2];
        box_color = [box_color, color];
        
        if strcmp(color, "yellow")  || strcmp(color, "green")
            fontColor = "black";
        else
            fontColor = "white";
        end
        font_color = [font_color, fontColor];
       
    end
     img = insertObjectAnnotation(img,"Rectangle",box_matrix,box_label,AnnotationColor = box_color, TextBoxOpacity=0.9,FontSize=30, LineWidth= 5, ...
         ShowOrientation = 0, FontColor=font_color);
       
     box_label = [];
     %etichetta e stampa le labels dei gruppi di carte
     for i = 1 : length(cards)
         current_card = cards{i};
         if ~strcmp(current_card.Symbol,  "gc") 
            continue;
         end
         mask = current_card.MASK;
         %chaimo la funzone create box quadrato
         position = crate_box1( position, mask);
         box_label= [box_label , "Gruppo di Carte"];
     end
     img = insertObjectAnnotation(img,"Rectangle",position,box_label, TextBoxOpacity=0.5,FontSize=20, LineWidth= 3, AnnotationColor="black", ...
         FontColor = "white");
     %stampa finale
     figure(1), imshow(img);
end

%disegna box corrispondente alla carta
function out = crate_box1(position, mask)
    figure(1);
    box = findbox(mask);
    xl = box(1,2);
    xr = box(1,1);
    ymin = box(1,3);
    ymax = box(1,4);
    width = abs(xl - xr);
    height = abs(ymin - ymax);
    
     rectangle = [xl, ymin, width, height];
     position = [position; rectangle];
    % figure(1);
    % 
    % box = findbox(mask);
    % xl = box(1,1);
    % xr = box(1,2);
    % ymin = box(1,3);
    % ymax = box(1,4);
    % hold on;
    % plot([xl, xr, xr, xl, xl], [ymin, ymin, ymax, ymax, ymin], 'w--', 'LineWidth', 2);
    % x = (xl + xr) / 2 - 100;
    % y = ymin - 20;
    % 
    % if isnumeric(value)
    %     commento = [ num2str(value),  color];
    % else 
    %     commento = [ value, color];
    % end
    %  text(x, y, commento, 'Color', 'b', 'FontSize', 8, 'FontWeight', 'bold');
    %   hold off;
    out = position;
end


function  out = create_box2(box_matrix,  mask_general)
     %estraggo centroide e angolo della label
    stats = regionprops(mask_general, "Centroid", "Orientation", "MajorAxisLength", "MinorAxisLength");
    centroid = stats.Centroid;
    cx = centroid(1);
    cy = centroid(2);
    theta = stats.Orientation;

    %estraggo dimensioni della maschera
    width =stats.MajorAxisLength;
    height = stats.MinorAxisLength;
    %creo la box e la aggiungo alla matrice di bbox
    bbox = [cx, cy, width, height, -theta];
    box_matrix(size(box_matrix, 1) + 1, : ) = bbox;
   
  out =  box_matrix;

end