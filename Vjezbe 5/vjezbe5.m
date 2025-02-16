% 1

a = 10; 
b = 10; 
T = 1;
M = 256; 
N = 256; 

[u, v] = meshgrid(0:N-1, 0:M-1);
u = u - N/2; 
v = v - M/2; 

H = exp(-pi^2 * T^2 * (u.^2 / a^2 + v.^2 / b^2));

figure
surf(u, v, H)
shading interp;
title('Funkcija prenosa operatora zamućenja');
xlabel('u'); 
ylabel('v'); 
zlabel('H(u, v)');

% 2

lena = imread('lena.jpg');
lena_double = im2double(lena);
[M, N] = size(lena_double);

lena_fft = fft2(lena_double);
lena_shifted = fftshift(lena_fft);

lena_blurred = H .* lena_shifted;
lena_blurred_shifted = ifftshift(lena_blurred);
lena_inversed = real(ifft2(lena_blurred_shifted));

variance = 1e-6;
lena_noisy = imnoise(lena_inversed, 'gaussian', 0, variance);

figure
imshow(lena_inversed, []);
title('Zamućena slika');

figure
imshow(lena_noisy, []);
title('Zamućena slika sa Gausovim šumom');

% 3

epsilon = 1e-6;
H_inv = 1 ./ (H + epsilon);
lena_restored_FFT = H_inv .* fftshift(fft2(lena_noisy));
lena_restored = real(ifft2(ifftshift(lena_restored_FFT)));

figure
imshow(Lena_restored, []);
title('Rezultat inverznog filtriranja');

%Poremecaj (sum) nije uklonjen

% 4

n = 50; 
D0 = 0.25 * M;
D = sqrt(u.^2 + v.^2);
H_butterworth = 1 ./ (1 + (D ./ D0).^(2 * n));

lena_butterworth_FFT = H_butterworth .* fftshift(fft2(lena_restored));
lena_butterworth = real(ifft2(ifftshift(lena_butterworth_FFT)));

figure
imshow(Lena_butterworth, []);
title('Butterworth niskopropusno filtriranje (D0 = 0.25)');

%Filter smanjuje sum u odnosu na prethodni zadatak

% 5

D0_values = [0.15, 0.2, 0.27, 0.3] * M;
figure;
for i = 1:length(D0_values)
    H_butterworth = 1 ./ (1 + (D ./ D0_values(i)).^(2 * n));
    lena_filtered_FFT = H_butterworth .* fftshift(fft2(lena_restored));
    lena_filtered = real(ifft2(ifftshift(lena_filtered_FFT)));
    subplot(2,2,i)
    imshow(Lena_filtered, []);
    title(['Butterworth filtriranje, D0 = ', num2str(D0_values(i)/M)]);
end

%Smanjivanjem vrijednosti D0 slika postaje zamucenija, a povecanjem se zadrzavaju detalji, kao i sum

% 6

Sn = 1e-6;
Sf = abs(lena_blurred).^2 / M / N;

H_wiener = conj(H) ./ (abs(H).^2 + Sn ./ Sf);
lena_wiener_FFT = H_wiener .* fftshift(fft2(lena_noisy));
lena_wiener = real(ifft2(ifftshift(lena_wiener_FFT)));

figure
imshow(Lena_wiener, []);
title('Rezultat Wienerovog filtriranja');

%Slika je poboljsana u odnosu na rezultat inverznog filtriranja, a zamucenje je djelimicno uklonjeno

% 7

K_values = [1e-6, 1e-5, 1e-4, 1e-3];
figure;
for i = 1:length(K_values)
    H_wiener_param = conj(H) ./ (abs(H).^2 + K_values(i));
    lena_wiener_param_FFT = H_wiener_param .* fftshift(fft2(lena_noisy));
    lena_wiener_param = real(ifft2(ifftshift(lena_wiener_param_FFT)));
    subplot(2,2,i)
    imshow(lena_wiener_param, []);
    title(['Parametarski Wiener filtar, K = ', num2str(K_values(i))]);
end

%Za manje vrijednosti rezultat je ostrija slika sa pojacanim sumom, a za vece se smanjuje sum, ali je i slika zamucenija

% 8

noise = 0;
lena_noisy_zero = imnoise(lena_inversed, 'gaussian', 0, noise);

figure
imshow(lena_noisy_zero, []);
title('Zamućena slika sa šumom 0');

%Za sum jednak nuli slika je idealno zamucena, a sum nije pristuan, pa je rezultat ostra slika

