function symbol = template_match(img)
    % Creo cella in cui salvare grafici e picchi
    distance  = cell(2, 15);  
    for i = 0 : 14
        t = getT(i);
    
        c = normxcorr2(t, img);
        
        % Salvo picchi e grafici per ogni rimbolo
        distance{1,i+1} = c;
        distance{2,i+1} = max(c(:));
    end
    
    symbol = find_smbl(distance);
   
end

% Preleva il simbolo
function t = getT(smbl)

    base_path = "../dataset/templates/";

    img = imread(base_path + smbl + ".jpg");
    % Ridimensiono per ottenere dimensione media di un simbolo nella carta
    img_r = imresize(img, 0.055);
    % Converto in HSV e prendo canale V binarizzato
    hsv = rgb2hsv(img_r);
    t = hsv(:,:,3); % Lavoro con il canale v 
end

% Calcola il picco massimo e attribuisce il simbolo corrispondente
function smbl = find_smbl(distance)
    symbol_lut = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eigth", "nine", "cg", "jt", "p2",  "p4", "cc"];

    % Estraggo 2 righe (picchi) , trovo il massimo e il simbolo corrispondente
    peaks = vertcat(distance{2,:});
    peak = max(peaks);

    if peak > 0.55
        smbl = symbol_lut(peaks == peak);
    else
        smbl = "unknown";
    end
    
    % Per debug o info posso estrarre il grafico
    % c = distance{1,index};
end

