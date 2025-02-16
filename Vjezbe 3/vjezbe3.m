% 1

lena = imread('lena.jpg');

figure
imshow(lena)
title('Originalna slika');

filter3 = fspecial('average', [3 3]); % Filtar 3x3
filter5 = fspecial('average', [5 5]); % Filtar 5x5
filter7 = fspecial('average', [7 7]); % Filtar 7x7

uniform_filter3 = imfilter(lena, filter3, 'same');
uniform_filter5 = imfilter(lena, filter5, 'same');
uniform_filter7 = imfilter(lena, filter7, 'same');

figure
imshow(uniform_filter3)
title('Uniformni filtar 3x3');

figure
imshow(uniform_filter5)
title('Uniformni filtar 5x5');

figure
imshow(uniform_filter7)
title('Uniformni filtar 7x7');

%Povecanjem reda filtra dolazi do izrazajnijeg zamucenja slike
%Detalji slike postaju manje vidljivi, a time se smanjuje kontrast i karakteristike slike (ivice objekata)

% 2

uniform_filter7_replicate = imfilter(lena, filter7, 'replicate', 'same');

figure
imshow(uniform_filter7_replicate)
title('Uniformni filtar 7x7 sa replicate opcijom');

%Koristenjem replicate rubne vrijednosti ostaju stabilne

% 3

lena_double = im2double(lena);

lena_noisy_sp10 = imnoise(lena_double, 'salt & pepper', 0.1);

figure
imshow(lena_noisy_sp10)
title('Slika sa salt & pepper šumom');

uniform_filter3_noisy = imfilter(lena_noisy_sp10, fspecial('average', [3 3]), 'replicate');
wiener_filter3_noisy = wiener2(lena_noisy_sp10, [3 3]);
wiener_filter5_noisy = wiener2(lena_noisy_sp10, [5 5]);
median_filter3_noisy = medfilt2(lena_noisy_sp10, [3 3]);

figure
imshow(uniform_filter3_noisy)
title('Uniformni filtar 3x3');

figure
imshow(wiener_filter3_noisy)
title('Wienerov filtar 3x3');

figure
imshow(wiener_filter5_noisy)
title('Wienerov filtar 5x5');

figure
imshow(median_filter3_noisy)
title('Median filtar 3x3');

mse_uniform_filter3 = immse(uniform_filter3_noisy, lena_double);
mse_wiener_filter3 = immse(wiener_filter3_noisy, lena_double);
mse_wiener_filter5 = immse(wiener_filter5_noisy, lena_double);
mse_median_filter3 = immse(median_filter3_noisy, lena_double);

disp(['MSE Uniform 3x3: ', num2str(mse_uniform_filter3)]);
disp(['MSE Wiener 3x3: ', num2str(mse_wiener_filter3)]);
disp(['MSE Wiener 5x5: ', num2str(mse_wiener_filter5)]);
disp(['MSE Median 3x3: ', num2str(mse_median_filter3)]);

%Najbolje rezultate daje median filtar 3x3 jer efikasno uklanja ovu vrstu suma bez veceg zamucenja detalja
%Zamjenjuju se pikseli medijanom u lokalnom opsegu cime se zanemarjuju ekstremne vrijednosti
%MSE za median je najmanjji sto znaci da ima najbolju ocuvanost originalnih karakteristika slike

% 4

lena_noisy_gaussian = imnoise(lena_double, 'gaussian', 0, 0.005);

figure
imshow(lena_noisy_gaussian)
title('Slika sa Gausovim šumom');

uniform_filter3_gauss = imfilter(lena_noisy_gaussian, fspecial('average', [3 3]), 'replicate');
wiener_filter3_gauss = wiener2(lena_noisy_gaussian, [3 3]);
wiener_filter5_gauss = wiener2(lena_noisy_gaussian, [5 5]);
median_filter3_gauss = medfilt2(lena_noisy_gaussian, [3 3]);

figure
imshow(uniform_filter3_gauss)
title('Uniformni filtar 3x3');

figure
imshow(wiener_filter3_gauss)
title('Wienerov filtar 3x3');

figure
imshow(wiener_filter5_gauss)
title('Wienerov filtar 5x5');

figure
imshow(median_filter3_gauss)
title('Median filtar 3x3');

mse_uniform_gauss = immse(uniform_filter3_gauss, lena_double);
mse_wiener3_gauss = immse(wiener_filter3_gauss, lena_double);
mse_wiener5_gauss = immse(wiener_filter5_gauss, lena_double);
mse_median_gauss = immse(median_filter3_gauss, lena_double);

disp(['MSE Uniform: ', num2str(mse_uniform_gauss)]);
disp(['MSE Wiener 3x3: ', num2str(mse_wiener3_gauss)]);
disp(['MSE Wiener 5x5: ', num2str(mse_wiener5_gauss)]);
disp(['MSE Median: ', num2str(mse_median_gauss)]);

%U ovom slucaju Wienerov filtar sa zadatom varijansom daje najmanju MSE jer se koristi za uklanjanje ovog tipa suma
%Razlika u odnosu na prethodni zadatak je da median nije efikasan za ovaj sum zato sto ne ignorise male varijacije

% 5

uniform5 = fspecial('average', [5 5]); % Uniformni filtar 5x5
uniform5_filter = imfilter(lena, uniform5, 'replicate');

laplacian = fspecial('laplacian', 0.2); % Laplasov filtar
laplacian_filter = imfilter(uniform5_filter, laplacian, 'replicate');

result = uniform5_filter - laplacian_filter;

figure
imshow(uniform5_filter)
title('Uniformni filtar 5x5');

figure
imshow(laplacian_filter, [])
title('Laplasov filtar');

figure
imshow(result, [])
title('Razlika između uniformnog i Laplasovog filtra');

%Skaliranje razlike na [0, 1]

scaled_result = mat2gray(result);

figure
imshow(scaled_result)
title('Skalirana razlika [0, 1]');

%Laplasov filtar istice ivice u slici jer koristi metodu promjene u intenzitetu piksela
%Razlika s uniformnim je u nacinu naglasavanja detalja slike (ivice)
%Tehnika se zove unsharp masking i koristi se za poboljsanje detalja uklanjanjem zamucenja

% 6

uniform_filter5_gauss = imfilter(lena_noisy_gaussian, uniform5, 'replicate');

laplacian_filter_gauss = imfilter(uniform_filter5_gauss, laplacian, 'replicate');

result_gauss = uniform_filter5_gauss - laplacian_filter_gauss;

figure
imshow(uniform_filter5_gauss)
title('Uniformni filtar 5x5 na Gausov šum');

figure
imshow(laplacian_filter_gauss, []) 
title('Laplasov filtar na uniformni rezultat');

figure
imshow(result_gauss, [])
title('Razlika za Gausov šum');

% Skaliranje razlike na [0, 1]
scaled_result_gauss = mat2gray(result_gauss);

figure
imshow(scaled_result_gauss)
title('Skalirana razlika za Gausov šum [0, 1]');

%Losa strana ove tehnike je sto na slici sa sumom Laplasov filter dodatno naglasava sum cime se smanjuje kvalitet