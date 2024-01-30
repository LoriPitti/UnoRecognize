
%data una label in input, la decrive secondo alcuni descrittpro quali
%area,perimetro, spazio occuapto etc
function out = describe_fig(fig)
    %caclolo area
    area = sum(fig(:));
    %calcolo sfondo
    back = sum(fig(:) == 0);
    %faccio il rapporto area/sfondo
    perc = area/back * 100;

    %calcolo il perimetro
    bw = bwboundaries(fig,8,'noholes');
    p = size(bw{1,1},1); 

    %rapporto area perimetro

    out = [p/area, p, perc];

end