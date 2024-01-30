% La seguente funzione ritaglia un quadrato in alto a sx in ogni carta e lo
% analizza : se è prevalentemente nero allora potrebbe essere una carta
% girata, dunque non andrà eseguito il template_match.
function out = is_card(mask, rgb)

	average_threshold = 0.32;

	%estraggo immagine grante quanto la carta
	box = findbox(mask);
	xl = box(1,1);
	xr=box(1,2);
	ymin = box(1,3);
	ymax = box(1,4);
	width = round(xl - xr);
	height = round(ymax - ymin);

	%creo l' immagine
	img = zeros(height + 1, width + 1);
	img(:,:)= rgb(ymin : ymax, xr : xl);

	for i = 1 : 2
		%creo quadrato e ritaglio la prozione di carta in alto a sx
		dim = size(img);
		xm = round(dim(2)/2);
		ym = round(dim(1)/2);
		%creo dimensioni e posizone quadrante
		xl = xm - 55; %60
		ymin = ym - 90;
		d = 30;
		xr = xl + d;
		ymax = ymin + d;
		%hold on;
		% plot([xl, xr, xr, xl, xl], [ymin, ymin, ymax, ymax, ymin], 'r-', 'LineWidth', 2);
		%hold off;
		%
        % figure(90), imshow(img);
		 % hold on ;
		 % plot([xl, xr, xr, xl, xl], [ymin, ymin, ymax, ymax, ymin], 'w--', 'LineWidth', 2);
		 % hold off;
		
		square = zeros(d + 1 , d +1);
		square(:,:) = img(ymin : ymax, xl : xr);
		square = square > average_threshold;
		% subplot(1,2,2), imshow(square);
		
		num = sum(square(:) == 0); %conta il nunero di zeri
		tot = d * d; %totale numero di pixel
		%se la percentuale di nero è più della metà allora non  è una carta ma
		%un retro ( false card )
		if num/tot * 100 > 95
			card = false;
			break;
		else
			card = true;
			img = imrotate(img, 180);
		end
	end
	out = card;

end
