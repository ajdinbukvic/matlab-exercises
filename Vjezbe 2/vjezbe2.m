% 1

doc imhist

help imhist

%MATLAB koristi 256 nivoa intenziteta za histogram slike kada se taj podatak ne specificira.

% 2

a = imread('pout.tif');

figure, imshow(a);
title('Originalna slika pout.tif');

figure, imhist(a);
title('Histogram slike pout.tif');

a_double = im2double(a);

%Histogram slike pout.tif pokazuje ograničenu pokrivenost dinamičkog opsega jer većina intenziteta piksela nije ravnomjerno raspoređena.
%Ppikseli su uglavnom koncentrisani u određenom užem dijelu spektra. 
%Ova karakteristika ukazuje na manji kontrast slike.

% 3

% Linearna transformacija
b = (a_double - 0.3) / (0.65 - 0.3);
b(b < 0) = 0;
b(b > 1) = 1;

figure, imshow(b);
title('Transformisana slika sa opsegom [0, 1]');

figure, imhist(b, 256);
title('Histogram transformisane slike');

%Na slici se povećava kontrast u tom opsegu, što se vidi i na histogramu jer su vrijednosti intenziteta sada ravnomjernije raspoređene unutar novog opsega.

% 4

c = imread('cameraman.tif');

figure, imshow(c);
title('Originalna slika cameraman.tif');

figure, imhist(c);
title('Histogram slike cameraman.tif');

% 5

c_double = im2double(c);

% Transformacija opsega u [0.5, 1]
d = (c_double - 0.3) / (0.6 - 0.3) * 0.5 + 0.5;
d(d < 0) = 0;
d(d > 1) = 1;

figure, imshow(d);
title('Transformisana slika sa opsegom kaputa [0.5, 1]');

%Linearno preslikavanje opsega intenziteta kaputa u [0.5, 1] povećava njegovu jasnoću, čineći kaput svjetlijim i istaknutijim na slici. 
%Pozadina ostaje manje promijenjena jer nije obuhvaćena ovim opsegom.

% 6

negativ_slika = imcomplement(c);

figure, imshow(negativ_slika);
title('Negativ slike cameraman.tif');

%Funkcija imcomplement generiše negativ slike tako što invertuje vrijednosti intenziteta, što znači da se svijetli dijelovi postaju tamni i obrnuto.

% 7

gama_korekcija_05 = imadjust(c_double, [], [], 0.5);
figure, imshow(gama_korekcija_05);
title('Gamma korekcija sa gamma = 0.5');

gama_korekcija_15 = imadjust(c_double, [], [], 1.5);
figure, imshow(gama_korekcija_15);
title('Gamma korekcija sa gamma = 1.5');

%Sa gamma = 0.5, slika postaje svjetlija, naglašavajući tamne tonove.
%Sa gamma = 1.5, slika postaje tamnija, što naglašava svjetlije tonove.
%Gamma korekcija je korisna za podešavanje svjetline slike na osnovu specifičnih potreba prikaza.

% 8

ekvalizirana_slika = histeq(c, 256);

figure, imshow(ekvalizirana_slika);
title('Ekvalizirana slika cameraman.tif');

figure, imhist(ekvalizirana_slika, 256);
title('Histogram ekvalizirane slike');

%Ekvalizacija histograma povećava kontrast slike.
%Histogram postaje ravnomjerniji, što znači da su intenziteti bolje raspoređeni.

% 9

% Normalizovani histogram
p = imhist(c, 256) / numel(c);
T = cumsum(p);

figure, plot((0:255)/255, T);
title('Kumulativna funkcija raspodjele intenziteta');

[ekvalizirana_slika, T2] = histeq(c, 256);
figure, plot((0:255)/255, T2);
title('Kumulativna funkcija raspodjele (histeq)');