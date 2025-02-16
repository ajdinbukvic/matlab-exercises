% 1

h = zeros(256); 
h(125:132, 125:132) = 1;

figure
mesh(h);
title('Pravougaoni kernel - 3D prikaz');

figure
imshow(h, []);
title('Pravougaoni kernel - 2D prikaz');

% 2

fourier = fft2(h);
magnitude = abs(fourier);

figure
mesh(magnitude);
title('Magnituda spektra');

centered_fourier = fftshift(fourier);
centered_magnitude = abs(centered_fourier);

figure
mesh(centered_magnitude);
title('Magnituda spektra - centrirana');

%Slicnost izmedju spektra dvodimenzionalnog i jednodimenzionalnog pravougaonika signala je u raspodjeli centralnih i sporednih rubova
%Ukoliko se ovaj konvolucioni kernel iskoristi za filtriranje rezultirat ce zamucenjem (niskopropusni filter) zato sto uklanja visoke frekvencije

% 3

figure
imshow(magnitude, []);
title('Magnituda spektra');
colorbar;

figure
imshow(centered_magnitude, []);
title('Magnituda spektra - centrirana');
colorbar;

% 4

S = log(1 + abs(centered_fourier));

figure
imshow(S, []);
title('Log-transformisana magnituda spektra');
colorbar;

% 5

lena = imread('lena.jpg');

lena_fourier = fft2(lena);

lena_magnitude = abs(lena_fourier);
lena_phase = angle(lena_fourier);

lena_log_magnitude = log(1 + lena_magnitude);

figure
imshow(lena_log_magnitude, []);
title('Magnituda Furijeove transformacije');
colorbar;

figure
imshow(lena_phase, []);
title('Faza Furijeove transformacije');
colorbar;

% 6

lena_only_magnitude = ifft2(abs(lena_fourier));

lena_only_phase = ifft2(exp(1j * lena_phase));

figure
imshow(real(lena_only_magnitude), []);
title('Rekonstrukcija sa samo magnitudom');

figure
imshow(real(lena_only_phase), []);
title('Rekonstrukcija sa samo fazom');

%Faza nozi prostorne informacije, a magnituda odredjuje energiju (bez faze slika gubi prostornu "energiju")

% 7

lena_double = im2double(lena);

uniform_filter11 = fspecial('average', [11 11]);

% Frekvencijsko filtriranje
[M, N] = size(lena_double);
H = fft2(uniform_filter11, M, N); % Filtriranje dopunjavanje nulama
F_lena = fft2(lena_double);
filtered_freq = F_lena .* H;
filtered_image_freq = real(ifft2(filtered_freq));

% Prostorno filtriranje
spatial_filtered = imfilter(lena_double, uniform_filter11, 'same');

figure
imshow(filtered_image_freq, []);
title('Frekvencijsko filtriranje');

figure
imshow(spatial_filtered, []);
title('Prostorno filtriranje');

%Uticaj dopunjavanja nulama (padding) prilikom racunanja Furijeove transformacije na rezultat je zbog izbjegavanja periodicnog preslikavanja u frekvencijskom domenu
%Frekvencijsko i prostorno filtriranje daju slicne rezultate, ali frekvencijsko je efikasnije za vecinu slika

% 8

lena_interference = imread('lena_em_interference.jpg');
lena_interference_double = im2double(lena_interference);

fourier_interference = fft2(lena_interference_double);
fourier_interference_centered = fftshift(fourier_interference);

magnitude_interference = abs(fourier_interference_centered);
log_magnitude_interference = log(1 + magnitude_interference);

figure
imshow(log_magnitude_interference, []);
title('Amplitudni spektar sa interferencijom');
colorbar;

% Uklanjanje interferencije
[M, N] = size(fourier_interference_centered);
% Identifikacija ucestanosti koje odgovaraju šumu
mask = ones(M, N);
% Postavljanje koeficijenata u spektru na nulu
mask(124:132, :) = 0;
mask(:, 124:132) = 0;

fourier_filtered = fourier_interference_centered .* mask;

result = real(ifft2(ifftshift(fourier_filtered)));

figure
imshow(result, []);
title('Slika bez periodičnog šuma');

% 9

% Dimenzije spektra
[M, N] = size(lena_interference_double);
[u, v] = meshgrid(-N/2:(N/2)-1, -M/2:(M/2)-1);
u = u / max(abs(u(:))); % Normalizacija
v = v / max(abs(v(:))); % Normalizacija

% Parametri filtra
u0 = 0.1; % Centralna frekvencija (horizontalno)
v0 = 0.1; % Centralna frekvencija (vertikalno)
D0 = 0.05; % Radijus
n = 2;    % Red filtra

% Batervortov notch filter
D1 = sqrt((u - u0).^2 + (v - v0).^2);
D2 = sqrt((u + u0).^2 + (v + v0).^2);
H = 1 ./ (1 + (D0^2 ./ (D1 .* D2)).^n);

H_shifted = fftshift(H);

figure
mesh(H_shifted);
title('Batervortov notch filter');
xlabel('u'); ylabel('v'); zlabel('H(u,v)');

% 10

fourier_interference_centered_filtered = fourier_interference_centered .* H_shifted;

filtered = real(ifft2(ifftshift(fourier_interference_centered_filtered)));

figure
imshow(lena_interference_double, []);
title('Originalna slika sa šumom');

figure
imshow(filtered, []);
title('Filtrirana slika bez šuma');
