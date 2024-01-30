%--------------FUNZIONE PER CREARE BOUNDING BOX-----------------
%cerco punti di minimo e max di figura
function box = findbox(bin)
    xleft = 1;
    xright = 1;
    ymin = 1;
    ymax = 1;
    
    dim = size(bin);
    for i = 1 : dim(1)
        for j = 1 : dim(2)
            if bin(i,j) == 1
                ymax = i; %punto superiore
                break;
            end
        end
    end

    for i = dim(1) : -1 : 1
        for j = 1 : dim(2)
            if bin(i,j) == 1
                ymin = i;   %punto più in basso
                break;
            end
        end
    end

    for j = 1 : dim(2)
        for i = 1 : dim(1)
            if bin(i,j) == 1
                xleft = j;  %ounto più a sinistra
                break;
            end
        end
    end

    for j = dim(2) : -1 : 1
        for i = 1 : dim(1)
            if bin(i,j) == 1
                xright = j; %punto più a dx
                break;
             end
        end
    end
    box = [xleft, xright, ymin, ymax];
end
