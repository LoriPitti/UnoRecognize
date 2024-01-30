function [out_card_color, out_predicted] =  classify_card_color(card_rgb, card_mask)
        
    [out_card_color, out_predicted] = classify_color(card_rgb, card_mask);
end


function [color, predicted] = classify_color(image, mask)   
        %knn = load("knn.mat");

        img = slice_card_by_box(image, mask);
        [height, width, n_channels] = size(img);

        classifier = load("./mat_files/color_classifier_model.mat").c;
        
        img = reshape(img, height*width, n_channels);

        predicted = predict(classifier, img);
        
        color = mode(predicted);
        switch color
            case 0.2
                color = "green";
            case 0.4 
                color ="yellow";
            case 0.6
                color = "blue";
            case 0.8 
                color = "red";
            case 1
                color = "other";
            % case 0
            %     color = "";
        end
        
    end