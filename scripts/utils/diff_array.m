%calcolo la differenza tra ogni valore negli array e ocntorllo  che siano
%minori degli epsilon itorni
function out = diff_array(a1, a2, epsilon)
    equal = true;
    for i = 1 : size(a1,2)
        %sottraggo
        diff = abs(a1(i) - a2(i));
        %se anche 1 valore è maggiore di epsilon allora non sono simili
        if diff > epsilon(i)
            equal = equal & false;
        end
    end
        out = equal;
end