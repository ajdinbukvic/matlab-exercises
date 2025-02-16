% 1

rice = imread('rice.png');

figure
imshow(rice);
title('Originalna slika - rice');

% 2

k_size = 50;
uniform_kernel = fspecial('average', k_size);

background = imfilter(rice, uniform_kernel, 'replicate');

figure
imshow(background, []);
title('Estimacija pozadine pomocu uniformnog kernela');

%Koristi se opcija replicate za prosirivanje rubnih vrijednosti slike
%Kada bi se koristila neka druga opcija rezultati ne bi bili realni na rubovima

% 3

difference = rice - background;

figure
imshow(difference, []);
title('Rezultat oduzimanja pozadine');

difference_ajdusted = imadjust(difference);

figure
imshow(difference_ajdusted, []);
title('Poboljsana slika nakon povecanja kontrasta');

%Oduzimanje procijenjene pozadine od originalne slike naglasava prednje objekte (zrna)
%Poboljsanje slike povecava kontrast kako bi bio bolji vizuelni izgled

% 4

rice_log = log(double(rice) + 1);

[M, N] = size(rice_log);
[u, v] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
D = sqrt(u.^2 + v.^2);
D0 = 0.05 * max(D(:)); 
n = 2; 

HNP = 1 ./ (1 + (D ./ D0).^(2 * n)); 
HVP = 1 - HNP; 

F = fft2(rice_log);
F_hp = HNP.*F;
rice_fft = fft2(rice_log);
rice_fft_shifted = fftshift(rice_fft);

a = 0.6; 
b = 1.7;
H_homomorphic = a + b * HVP;
rice_filtered = H_homomorphic .* rice_fft_shifted;

rice_filtered_shifted = ifftshift(rice_filtered);
rice_homomorphic = real(ifft2(rice_filtered_shifted));

rice_final = exp(rice_homomorphic) - 1;

figure
imshow(rice_final, []);
title('Rezultat homomorfnog filtriranja');

%Na osnovu prethodnog rezultata oduzimanje pozadine uklanja sjenku, ali ne poboljsava kontrast u potpunosti
%Homomorfno filtriranje bolje uklanja neuniformno osvjetljenje i dodatno pojavava kontrast

