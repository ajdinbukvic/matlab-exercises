% 1

coins_img = imread('coins.png');

figure
imshow(coins_img)
title('Originalna slika');

figure
imhist(coins_img)
title('Histogram slike');

threshold = 100;
coins_binary = coins_img > threshold;

figure
imshow(coins_binary)
title('Binarna slika nakon segmentacije');

%Na histogramu se dijele tamni pikseli od pozadine i svjetliji za novcice
%Prag razdvaja tamne piksele pozadine od svjetlijih piksela novcica
%Rezultat binarne slike je odvajanje novcica kao objekata (bijeli pikseli)

% 2

function threshold = isodata_threshold(img)
    img = double(img);
    T = mean(img(:));
    delta = 1;
    while true
        g1 = img(img > T);
        g2 = img(img <= T);
        T_new = (mean(g1) + mean(g2)) / 2;
        if abs(T_new - T) < delta
            break;
        end
        T = T_new;
    end
    threshold = T;
end

threshold_isodata = isodata_threshold(coins_img);

coins_binary_isodata = coins_img > threshold_isodata;

figure
imshow(coins_binary_isodata)
title('Segmentacija ISODATA algoritmom');

%Ovim algoritmmom se automatski izracunava prag na osnovu srednjih vrijednosti piksela
%Dobijeni rezultat je zadovoljavajuci

% 3

threshold_otsu = graythresh(coins_img) * 255;

coins_binary_otsu = coins_img > threshold_otsu;

figure
imshow(coins_binary_otsu)
title('Segmentacija Otsuovim algoritmom');

%Prag izracunat ovim algoritmom je vrlo slican onom iz prethodnog zadatka

% 4

rice_img = imread('rice.png');

figure
imshow(rice_img)
title('Originalna slika');

figure
imhist(rice_img)
title('Histogram slike');

threshold_rice_otsu = graythresh(rice_img) * 255;

rice_binary_otsu = rice_img > threshold_rice_otsu;

figure
imshow(rice_binary_otsu)
title('Segmentacija Otsuovim algoritmom');

%Otsuov algoritam automatski izracunava dobar prag (odvajanje rzna rize od pozadine)

% 5

background = imopen(rice_img, strel('disk', 15));
rice_corrected = rice_img - background;

threshold_rice_corrected = graythresh(rice_corrected) * 255;
rice_binary_corrected = rice_corrected > threshold_rice_corrected;

figure
imshow(rice_binary_corrected)
title('Segmentacija nakon uklanjanja sjenčenja');

%Uklanjanjem sjencenja osvjetljenje je postalo uniformnije
%Segmentacija je postala preziznija

% 6

lena_img = imread('lena.jpg');

figure
imshow(lena_img)
title('Originalna slika');

figure
imhist(lena_img)
title('Histogram slike');

threshold_lena = graythresh(lena_img) * 255;
lena_binary = lena_img > threshold_lena;

figure
imshow(lena_binary)
title('Segmentacija Otsuovim algoritmom');

%Ova slika je teska za segmentaciju jer njen histogram ima sirok raspon vrijednosti cime je otezana segmentacija
%Rezultati nisu bas najbolji jer se dijelovi objekata stapaju s pozadinom

% 7

function lab = kmeans_segmentacija(im, no_reg, no_iter)
    [rows, cols, channels] = size(im);
    if channels ~= 3 
    end
    im_reshaped = double(reshape(im, rows * cols, 3));
    [idx, ~] = kmeans(im_reshaped, no_reg, 'MaxIter', no_iter);
    lab = reshape(idx, rows, cols);
end

% 8

epithel_img = imread('epithel.jpg');

lab_rgb = kmeans_segmentacija(epithel_img, 3, 100);

figure
imshow(label2rgb(lab_rgb))
title('Segmentacija u RGB prostoru');

% 9

img_lab = rgb2lab(epithel_img);
lab_lab = kmeans_segmentacija(img_lab, 3, 100);

figure
imshow(label2rgb(lab_lab))
title('Segmentacija u L*a*b* prostoru');

%L*a*b* dahe bolje rezultate u odnosu na RGB prostor jer razdvaja svjetlocu od boje

% 10

gray_img = rgb2gray(epithel_img);

gray_img = im2double(gray_img);

threshold_gray = graythresh(gray_img);

binary_gray = gray_img > threshold_gray;

figure
imshow(binary_gray)
title('Grayscale segmentacija');

%Ova segmentacija je manje precizna zbog nedostatka informacija o bojama

