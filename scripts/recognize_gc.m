function out_cards = recognize_gc(img, group_mask , original_mask)
	original_mask_box = getbox(original_mask);

	remaining_mask = group_mask;
	average_area = 3.0081e+04 / 5 ;

	dist =  10;
	desc = load("./mat_files/descrittori_ovale.mat").descrittori;
	delta_labels = 2100;
	%epsilo differenze array
	e1 = 0.0020;
	e2 = 30;
	e3 = 30;

	ycbcr = rgb2ycbcr(img);
	y = ycbcr(:,:,1);
	%binarizzo per togliere il bordo bianco
	y = not(y >= (180  / 255) ) ;

	%applico la morfologia matematica, in particolare un opeazione di OPEN
	%con un elemento strutturale
	% se = strel('disk',3);
	% y = imerode(y, se);

	labels = bwlabel(y);
	% imagesc(labels), axis image;

	[npixel, values] = imhist(uint8(labels));

	d = size(npixel);
	%pulsico l ' array di label
	for i = 1: d(1)
		if npixel(i) == 0
			values(i) = -1; %
		end
	end

	npixel = npixel(npixel ~= 0);
	values = values(values ~= -1);
	d = size(npixel);

	cards = {};
	h = 1; %indice cella di immagini finale
	for i = 2 : d(1)
		mask = labels == i-1;
		%calcolo l ' area delle labels
		area = npixel(i);
		%se è un ovale ( dimensione entro un certo range calcolato)
		if abs(area - 11000) <= delta_labels
			mask = imfill(mask, "holes");
			%figure(i + 60), imshow(mask);
			
			%-----CALCOLO LA SIGNATURE-------
			% signature = compute_signature(mask);
			% oval_signature = load("ovale_signature.mat").signature;
			%calcolo la distanza tra le signature dell' oggetto e quella
			%dell ovale  con il coeff di correalzione
			% min = Inf;
			% for k = 1 : size(oval_signature,2)
			%     for j = 1 : size(signature,2)
			%         %dist = signature_matching(oval_signature{k}, signature{j});
			%         %if dist < min
			%            % min = dist
			%        % end
			%         figure(80 + j), subplot(1,2,1), plot(oval_signature{k}), title('Corretto'), subplot(1,2,2), plot(signature{j});
			%     end
			% end
			
			%estraggo lunghezza degli assi, l' anglo e il centroide
			axis_props = regionprops("struct", mask, "MajorAxisLength","Centroid", "Orientation");
			alpha = axis_props.Orientation;
			centroid = axis_props.Centroid;
			c_x = centroid(1);
			c_y = centroid(2);
			ip = axis_props.MajorAxisLength / 2 + dist;
			%calcolo l' angolo del triangolo rettangolo
			if alpha < 0
				gamma = 90 + alpha;
			else
				gamma = 90 - alpha;
			end
			gamma = deg2rad(gamma);
			%calcolo i cateti
			a_or = ip * sin(gamma);
			b_ver = ip * cos(gamma);
			%se l' angolo è minore di 90 ( positico ) mi sposto verso basso
			%dc er alto dx, viceversa e è maggiore di 90 (negativo)
			if alpha < 0
				p1_x = (round(c_x + a_or)); % p1 = punto sotto
				p2_x = (round(c_x - a_or)); % p2 = punto sopra
			else
				p1_x = (round(c_x - a_or));
				p2_x = (round(c_x + a_or));
			end
			p1_y  = (round(c_y + b_ver));
			p2_y  = (round(c_y - b_ver));
			
			%ruoto in verticale l' img
			if alpha > 0
				theta = 90 - alpha;
			else
				% theta = 90 - abs(180 - alpha);
				theta = 90 + alpha;
				theta = - theta;
			end
			%ruoto l' immagine in verticale
			fig = imrotate(mask, theta);
			
			%creo immagine di dimensioni label
			box = findbox(fig);
			xleft = box(1,1);
			xright = box(1,2);
			ymin = box(1,3);
			ymax = box(1,4);
			
			width = abs(xright - xleft);
			height = abs(ymax - ymin);
			%creo un padding
			padding = 0;
			final = zeros(height + 1 , width + 1 );
			% fig(padding: height + padding, padding :  width + padding) = mask(ymin : ymax, xright : xleft);
			final(:,:) = fig(ymin : ymax, xright : xleft);
			% imshow(final);
			
			descrittori = describe_fig(final);
			descrittori = (descrittori);
			%controllo se gli array sono simili ( true o false )
			if diff_array(desc, descrittori, [e1,e2,e3]) == 0
				continue;
			end
			
			
			 % hold on;
			 % plot(c_x, c_y, 'yo', 'MarkerSize', 10);
			 % plot(p1_x, p1_y, 'go', 'MarkerSize', 10);
			 % plot(p2_x, p2_y, 'go', 'MarkerSize', 10);
			 % hold off;
			
			
			% mask_rotate = imrotate(mask, alpha-90);
			% figure(40 + 1 ) , imshow(mask_rotate);
			
			%estraggo l' intensità dei 2 pixel nelle rispettive coordinate
			val_1 = labels(p1_y, p1_x);
			val_2 = labels(p2_y, p2_x);
			
			mask = mask + (labels == val_1 )+ (labels == val_2);
			mask = imfill(mask, "holes");
			el1 = strel("disk", 20);
			el2 = strel("disk", 10);
			
			mask = imclose(mask, el1);
			mask = imdilate(mask, el2);
			%estraggo le coordinate assolute rispetto alla immagine
			%originale e genero maschera
			card_figure = slice_card_by_box(mask, mask);
			location_mask = generate_mask(mask, original_mask_box, card_figure,size(original_mask));
			
			%istanzio oggetto carta
			detected_card = DetectedObject(mask, extract_card_by_mask(img, mask));
			detected_card.Color = "";
			detected_card.Symbol = "undefined";
			detected_card.MASK = location_mask;
			
			remaining_mask = remaining_mask - not(uint8(y-mask).*255);
			cards{h} = detected_card;
			
			h = h+1;
			%figure(40 + i), subplot(1,2,2),imshow(final);
			
		end
	end
	%controllo se la riamnenza è un grupoo di carte o un rumore in base al
	%numero di pixel
	area = sum(remaining_mask(:));
	if area >= average_area
		%enero la maschwera nella immagine originale
		remaining_figure = slice_card_by_box(remaining_mask, remaining_mask);
		location_mask = generate_mask(remaining_mask, original_mask_box, remaining_figure,size(original_mask));
		%creo oggetto
		cards_junk = DetectedObject(remaining_mask, extract_card_by_mask(img, remaining_mask));
		cards_junk.Color = "";
		cards_junk.Symbol = "gc";
		cards_junk.MASK = location_mask;
		cards{length(cards) + 1} = cards_junk;
	end

	out_cards = cards;

	end
	%calcola le coordinate estreme della bbox
	function box = getbox(img)
	b = findbox(img);
	box.xleft = b(1,1);
	box.xright = b(1,2);
	box.ymin = b(1,3);
	box.ymax = b(1,4);
	end

	%crea la maschera grande quanto l' img originale
function out = generate_mask(mask, original_mask_box, card_figure, d)
	width = d(2);
	height = d(1);
	%uso la machera del gruppo di carte per estrarre le cooridnate della
	%box
	mask_box = getbox(mask);
	%calcolo coordiante assolute
	xl = original_mask_box.xright + mask_box.xleft;
	xr = mask_box.xright + original_mask_box.xright;
	ymi = original_mask_box.ymin  +  mask_box.ymin;
	yma = original_mask_box.ymin  + mask_box.ymax;

	%creo maschera finale
	location_mask = zeros(height, width);
	location_mask(ymi : yma , xr : xl) = card_figure;
	out = location_mask;

end

