function [out_rotated_img, out_rotated_mask]= rotate_images(varargin)
      
    if nargin==1
        mask = varargin{1};
        image_to_rotate = mask;
    elseif nargin == 2
        mask = varargin{2};
        image_to_rotate = varargin{1};
    end
    
    % Estrazione dei bordi degli oggetti
    img_edges = edge(mask,"roberts");
    
    [H, T, R] = hough(img_edges);
    % imagesc(H),colorbar,title('Spazio dei parametri della trasformata di Hough');
    
    % Ricerca dei 4 picchi, 1 per spigolo
    peaks = houghpeaks(H,4);
    rhos   = R(peaks(:,1));
    thetas = T(peaks(:,2));
    % Conversione da gradi a radianti
    thetas = thetas*pi/180;
    
    theta_longest_line = compute_angle(mask, rhos, thetas);
    
    % Rotazione immagine
    rotated_img = imrotate(image_to_rotate, theta_longest_line);
    rotated_mask = imrotate(mask, theta_longest_line);
    
    % Controllo della corretta rotazione
    box = findbox(rotated_mask); % Inquadramento carta
    x_left = box(1,1);
    x_right = box(1,2);
    y_max = box(1,4);
    y_min = box(1,3);
    
    width = abs(x_left - x_right);
    height = abs(y_max - y_min);
    % Se l' altezza è minore della lunghezza, significa che la carta è
    % orizzontale e va girata ancora di 90 gradi
    if height < width
        rotated_img = imrotate(rotated_img, 90);
        rotated_mask = imrotate(rotated_mask, 90);
    end
    %figure(2), subplot(1,2,1), imshow(rot), subplot(1,2,2), imshow(rot2);
    out_rotated_img = rotated_img;
    out_rotated_mask = rotated_mask;
end


function angle = compute_angle(img, rhos, thetas)
%subplot(1,2,2), imshow(img);
  X=[1:size(img,2) ]; % Tutti i valori delle coordinate x
 % hold on;
  for n = 1 : numel(rhos)
    Y=(rhos(n)-X*cos(thetas(n)))/sin(thetas(n)); % Valori delle coordinate y

    % Risoluzione su y dell'equazione rho=x*cos(theta)+y*sin(theta)
   % plot(X,Y,'r-', 'LineWidth', 1);
  end
    %hold off;
  % Estrazione del lato maggiore, corrisponde alla linea più lunga
  line_lengths = zeros(numel(rhos), 1);
  for n = 1:numel(rhos)
    line_lengths(n) = sqrt((X(end) - X(1))^2 + (Y(end) - Y(1))^2);
  end

  % Trova l'indice della linea più lunga
  [~, max_line_index] = max(line_lengths);

  % Estrazione della linea più lunga
  longest_line = [rhos(max_line_index), thetas(max_line_index)];
  % Calcola il coefficiente angolare
  angle =  rad2deg(longest_line(2)); %angolo retta
    
end