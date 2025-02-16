% 1

circbw_img = imread('circbw.tif');

figure
imshow(circbw_img)
title('Originalna binarna slika circbw.tif');

% 2

se = strel('square', 3);

dilated_img = imdilate(circbw_img, se);

figure
imshow(dilated_img)
title('Dilatacija sa 3x3 strukturnim elementom');

% 3

eroded_img = imerode(circbw_img, se);

figure
imshow(eroded_img)
title('Erozija sa 3x3 strukturnim elementom');

% 4

se_large = strel('square', 30);

opened_img = imopen(circbw_img, se_large);

figure
imshow(opened_img)
title('Otvaranje sa 30x30 strukturnim elementom');

% 5

closed_img = imclose(circbw_img, se_large);

figure
imshow(closed_img)
title('Zatvaranje sa 30x30 strukturnim elementom');

% 6

opened_img_3x3 = imopen(circbw_img, se);

opened_closed_img = imclose(opened_img_3x3, se);

figure
imshow(opened_closed_img)
title('Otvaranje i zatvaranje sa 3x3 strukturnim elementom');

% 7

sarafi_img = imread('sarafi.tif');

figure
imshow(sarafi_img)
title('Originalna grayscale slika sarafi.tif');

% 8

binary_sarafi = sarafi_img > 130;

figure
imshow(binary_sarafi)
title('Binarna slika sa pragom 130');

% 9

skeleton_with_endpoints = bwmorph(binary_sarafi, 'skel', Inf);

figure
imshow(skeleton_with_endpoints)
title('Skeleton sa krajnjim pikselima');

% 10

skeleton_without_endpoints = bwmorph(binary_sarafi, 'skel', Inf);
skeleton_without_endpoints = bwmorph(skeleton_without_endpoints, 'spur', Inf);

figure
imshow(skeleton_without_endpoints)
title('Skeleton bez krajnjih piksela');

% 11

salt_filtered_skeleton = bwmorph(skeleton_without_endpoints, 'clean');

figure
imshow(salt_filtered_skeleton)
title('Skeleton sa salt filtrom');

% 12

function result = conditional_dilation(input_img, mask, se)
    result = input_img;
    while true
        dilated = imdilate(result, se);
        new_result = dilated & mask; 
        if isequal(new_result, result)
            break; 
        end
        result = new_result;
    end
end

se_8 = strel('diamond', 1); 
cond_dilated_img = conditional_dilation(salt_filtered_skeleton, binary_sarafi, se_8);

figure
imshow(cond_dilated_img)
title('Uslovna dilatacija sa 8-povezanim elementom');
