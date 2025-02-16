% 1

% 2

a = imread('lena.jpg');

% 3

doc imread

help imread

%Funkcija imread podržava različite formate slika, kao što su BMP, PNG, JPEG, TIFF, GIF, i drugi.
%Različiti formati se mogu učitati korištenjem imread bez promjene sintakse. 
%Formati imaju različite karakteristike, npr. TIFF slike mogu sadržati više slojeva, dok su JPEG slike komprimirane.

% 4

size_a = size(a);  % Dimenzije slike
class_a = class(a);  % Klasa elemenata
min_val = min(a(:));  % Minimalna vrijednost
max_val = max(a(:));  % Maksimalna vrijednost

disp(['Dimenzije slike: ', mat2str(size_a)]);
disp(['Klasa elemenata: ', class_a]);
disp(['Opseg vrijednosti: ', num2str(min_val), ' - ', num2str(max_val)]);

%Objašnjenje: imread učitava sliku u formatu uint8, gdje su vrijednosti piksela između 0 i 255 za crno-bijele slike.

% 5

figure;
imshow(a);
%imtool(a);

% 6

figure;
imshow(a);
colorbar; % Dodaje skalu intenziteta na prikazanoj slici

% 7

figure;
imshow(a);
impixelinfo;  % Omogućava prikaz intenziteta piksela na slici

% 8

a_double = im2double(a);
figure;
imshow(a_double);

% 9

info = imfinfo('lena.jpg');

% 10

imwrite(a, 'lena.tiff');
imwrite(a, 'lena_kvalitet_50.jpg', 'Quality', 50);
imwrite(a, 'lena_kvalitet_25.jpg', 'Quality', 25);
imwrite(a, 'lena_kvalitet_15.jpg', 'Quality', 15);
imwrite(a, 'lena_kvalitet_5.jpg', 'Quality', 5);

% 11

info_blobs = imfinfo('blobs.tif');
blobs = imread('blobs.tif');
size_blobs = size(blobs);
class_blobs = class(blobs);

disp(['Dimenzije slike: ', mat2str(size_blobs)]);
disp(['Klasa elemenata: ', class_blobs]);

figure;
imshow(blobs);

% 12

dcm_slika = dicomread('CT_pluca.dcm');
dcm_info = dicominfo('CT_pluca.dcm');

dimenzije = size(dcm_slika);        
klasa = class(dcm_slika);           

disp(['Dimenzije slike: ', mat2str(dimenzije)]);
disp(['Klasa elemenata: ', klasa]);

figure;
imshow(dcm_slika);

%DICOM slike imaju veće dimenzije vrijednosti prilagođene za medicinske uređaje, a elementi matrice su obično u uint16 formatu.
%Pri prikazu DICOM slika bez podešavanja opsega, prikaz može izgledati loše jer imshow koristi automatski opseg intenziteta 0-255.
%Posto DICOM slike imaju vrijednosti vece od tog opsega, potrebno je definisati opseg kako bi prikaz bio precizniji.

% 13

figure;
imshow(dcm_slika, []);

figure;
imshow(dcm_slika, [864 1264]);

% 14

b = double(dcm_slika);
c = mat2gray(b, [864 1264]);

figure;
imshow(c);

%Ne dobija se isti rezultat, jer funkcija im2double samo konvertuje podatke iz uint16 u double, bez prilagođavanja opsega vrijednosti. 
%mat2gray vrši i skaliranje tih vrijednosti kako bi ih prilagodila opsegu [0, 1].
%Kada se koristi mat2gray(b, [864, 1264]), vrijednosti u opsegu od 864 do 1264 se mapiraju na opseg [0, 1], dok su sve vrijednosti ispod 864 prikazane kao 0, 
%a one iznad 1264 kao 1. Ovo omogućava jasniji prikaz slika, jer su svi nivoi intenziteta piksela skalirani na prepoznatljiv opseg boja.

% 15

ogledalo_slika = flip(a, 2); % Horizontalno ogledalo
figure;
imshow(ogledalo_slika);

lice_slika = a(100:200, 100:200, :); % Izdvajanje pod-matrice
figure;
imshow(lice_slika);

prorjedjena_slika = a(1:2:end, 1:2:end, :); % Prorjeđivanjem se uzima svaki drugi piksel.
figure;
imshow(prorjedjena_slika);
