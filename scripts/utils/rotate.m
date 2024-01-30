function [rotated_img, rotated_img2] = rotate_images(img, img2)
%estraggo i bordi
edg = edge(img,'sobel');
%----------------APPLICO HOUGH-------------------
[H, T, R] = hough(edg);
%trovo i picchi (4 spigoli quindi ne cerco 4 )
peaks = houghpeaks(H,4);
rhos   = R(peaks(:,1));
thetas = T(peaks(:,2));
% I valori di theta sono in gradi, ci servono i valori in radianti
thetas = thetas*pi/180;

%hold on
X=[1:size(img,2)]; % tutti i valori delle coordinate x
for n = 1 : numel(rhos)
  Y=(rhos(n)-X*cos(thetas(n)))/sin(thetas(n)); % valori delle coordinate y
  % Si risolve su y l'equazione rho=x*cos(theta)+y*sin(theta)
  %plot(X,Y,'r-', 'LineWidth', 1);
end
%hold off;

%----------------------ESTRAGGO LINEA PIù LUNGA ( lato maggiore)
lineLengths = zeros(numel(rhos), 1);
for n = 1:numel(rhos)
  lineLengths(n) = sqrt((X(end) - X(1))^2 + (Y(end) - Y(1))^2);
end

% Trova l'indice della linea più lunga
[~, maxIndex] = max(lineLengths);

% Estrai la linea più lunga
longestLine = [rhos(maxIndex), thetas(maxIndex)];
% Calcola il coefficiente angolare
theta_longestLine =  rad2deg(longestLine(2)); %angolo retta



%RUOTO L ' IMMAGINE DI LABEL
rot = imrotate(img,theta_longestLine);
rot2 = imrotate(img2, theta_longestLine);
%-------------CONTROLLO CHE SIA RUOTATA NEL SENSO GIUSTO
box = findbox(rot); % inquadro la carta e trovo l' altezza
xleft = box(1,1);
xright = box(1,2);
ymax = box(1,4);
ymin = box(1,3);
width = abs(xleft - xright);
height = abs(ymax - ymin);
% Se l' altezza è minore della lunghezza, significa che la carta è
% orizzonatale e va girata ancora di 90 gradi
if height < width
  rot = imrotate(rot, 90);
  rot2 = imrotate(rot2, 90);
end
%figure(2), subplot(1,2,1), imshow(rot), subplot(1,2,2), imshow(rot2);
rotated_img = rot; 
rotated_img2 = rot2;

end