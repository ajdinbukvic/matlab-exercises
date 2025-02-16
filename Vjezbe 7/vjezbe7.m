% 1

test_img = imread('test.tif');

figure
imshow(test_img);
title('Originalna test slika');

test_img_double = im2double(test_img);

figure
imshow(test_img_double);
title('Test slika u double formatu');

% 2

gx = [1 0; 0 -1];
gy = [0 1; -1 0];

grad_x = imfilter(test_img_double, gx, 'replicate');
grad_y = imfilter(test_img_double, gy, 'replicate');

figure
subplot(1,2,1)
imshow(grad_x, [])
title('Gradijent u smjeru x');
subplot(1,2,2)
imshow(grad_y, [])
title('Gradijent u smjeru y');

% 3

amplitude = sqrt(grad_x.^2 + grad_y.^2);
direction = atan2(grad_y, grad_x);

figure
subplot(1,2,1)
imshow(amplitude, [])
title('Amplituda gradijenta');
subplot(1,2,2)
imshow(direction, [])
title('Smjer gradijenta');

edges = amplitude > 0.1;

figure
imshow(edges)
title('Binarna slika ivica');

%Amplituda gradijenta naglasava ivice, a oblasti bez ostrih prijelaza su tamnije
%Binarna slika ivica prikazje detektovane ivice uz prag 0.1

% 4

test_img_noise = imnoise(test_img_double, 'gaussian', 0, 0.001);

figure
imshow(test_img_noise)
title('Slika sa Gausovim šumom');

roberts_amp = sqrt(imfilter(test_img_noise, gx, 'replicate').^2 + imfilter(test_img_noise, gy, 'replicate').^2);

figure
imshow(roberts_amp, [])
title('Robertsov filtar - Amplituda');

prewitt_amp = edge(test_img_noise, 'prewitt');

figure
imshow(prewitt_amp)
title('Prewittov filtar');

sobel_amp = edge(test_img_noise, 'sobel');

figure
imshow(sobel_amp)
title('Sobelov filtar');

%Robertsov filtar pokazuje brze promjene piksela, ali je osjetljiviji na sum
%Prewittom filtar daje glatkije ivice i otporniji je na sum
%Sobelov filtar daje najbolje rezultate i bolje detektuje kontinuitet ivica

% 5

log_filter = fspecial('log', [5 5], 0.5);
log_result = imfilter(test_img_double, log_filter, 'replicate');

figure
imshow(log_result, [])
title('LoG filtar');

%Ivice su jasno istaknute, ali su sire zbog efekta Gaussovog zamucenja
%Bolje se vrsi detekcija kruznih i zakrivljenih ivica

% 6

log_edge = edge(test_img_double, 'log');

figure
imshow(log_edge)
title('Edge - LoG filter');

%Ivice su detektovana preciznije nego u prethodnom zadatku jer se koristi automatsko odredjivanje praga

% 7

house = imread('kuca.tif');
house_double = im2double(house);

roberts_house = edge(house_double, 'roberts');
sobel_house = edge(house_double, 'sobel');
log_house = edge(house_double, 'log');

figure;
subplot(1,3,1)
imshow(roberts_house)
title('Roberts');
subplot(1,3,2)
imshow(sobel_house)
title('Sobel');
subplot(1,3,3)
imshow(log_house)
title('LoG');

% 8

sobel_edge = edge(house_double, 'sobel', 0.05); 

figure
imshow(sobel_edge)
title('Sobel sa podešenim parametrima');

%Nizi prag detektuje vise ivica i ukljucuje sum, a visi detektuje samo znacajnije ivice

% 9

f = zeros(101);
f(1,1) = 1; 
f(101,1) = 1; 
f(1,101) = 1; 
f(101,101) = 1; 
f(51,51) = 1;

figure
imshow(f)
title('Binarna test slika');

[H, theta, rho] = hough(f);

figure
imshow(H, [], 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit')
title('Houghova transformacija')
xlabel('\theta')
ylabel('\rho');

%Transformacijom u Houghow prostor svaka linija ima odgovarajucu krivulju

% 10

[H, theta, rho] = hough(sobel_house);
peaks = houghpeaks(H, 5);
lines = houghlines(sobel_house, theta, rho, peaks);

figure
imshow(house_double)
hold on;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');
end
title('Prikaz Houghovih linija');

% ZADATAK S ČASA

% I=imread('lenacolor.jpg');
% grayI=rgb2gray(I);
% 
%  %primjena funkcije edge sa Canny metodom
% edgeImage=edge(grayI, 'canny');
% 
% %Izra?unavanje Houghove transformacije
% [H, theta, rho]=hough(edgeImage);
% 
% %Prikazivanje Houghove transformacije
% figure,imshow(imadjust(rescale(H)),'XData',theta,'YData',rho,'InitialMagnification','fit');
% xlabel('\theta'), ylabel('\rho');
% title('Houghova transformacija');
% axis on, axis normal;
% hold on;
% 
% %Pronalaženje lokalnih minimuma Hoghove trasformacije
% peaks=houghpeaks(H,5);
% 
% %Detekcija linijskih segmenata
% lines=houghlines(edgeImage, theta, rho, peaks, 'FillGap',30, 'MinLength', 10);
% %Prikaz originalne slike sa detektovanim linijama
% figure;
% imshow(I);
% hold on;
% for k = 1:length(lines) 
%  xy = [lines(k).point1; lines(k).point2]; 
%  plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green'); 
% 
%  % ozna?avanje po?etaka i krajeva linija
%  plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow'); 
%  plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red'); 
% end