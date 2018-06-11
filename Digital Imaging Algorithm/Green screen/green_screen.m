clear all
clc

im1 = imread('godzilla_1.jpg');
im2 = imread('godzilla_2.jpg');

im1 = im2double(im1);
im2 = im2double(im2);

figure, imshow(im1)

crop1 = imcrop(im1);
crop2 = imcrop(im1);

figure,
subplot(1,2,1), imshow(crop1),
subplot(1,2,2), imshow(crop2)
%%
crop1 = rgb2ycbcr(crop1);
crop2 = rgb2ycbcr(crop2);
crop1 = reshape(crop1, [], 3);
crop2 = reshape(crop2, [], 3);
stats1 = [mean(crop1) std(crop1)];
stats2 = [mean(crop2) std(crop2)];
%%
im1_ycbcr = rgb2ycbcr(im1);
s = size(im1);
im1_ycbcr = reshape(im1_ycbcr, [], 3);
mask = zeros(size(im1_ycbcr,1),1);

u = find(abs(im1_ycbcr(:,2)-stats1(2)) < 4*stats1(5) & ...
         abs(im1_ycbcr(:,3)-stats1(3)) < 4*stats1(6) );
mask(u)= 1;
u = find(abs(im1_ycbcr(:,2)-stats2(2)) < 4*stats2(5) & ...
         abs(im1_ycbcr(:,3)-stats2(3)) < 4*stats2(6) );
mask(u)= 1;

mask = reshape(mask, s(1), s(2));

figure(3), imshow(mask)

mask = repmat(mask, 1,1,3);

%%

se1 = strel('disk',7);

mask = imdilate(mask, se1);
figure(3), imshow(mask)

mask = imerode(mask,se1);
figure(3), imshow(mask)

%%
im_cc = (1-mask).* im1 + mask .* im2;
figure, imshow(im_cc)