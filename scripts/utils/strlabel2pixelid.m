function out_pixel_id = strlabel2pixelid(string_label, labels)
    
    % isp(string_label);
    
    row = find(strcmp(labels.S.Name, string_label));
    
    out_pixel_id = labels.S(row, :).PixelLabelID{1};

end