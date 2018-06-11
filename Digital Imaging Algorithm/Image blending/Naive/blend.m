clear all

im1 = imread('image1.bmp');
im2 = imread('image2.bmp');

size(im1)
size(im2)

im1 = im2double(im1);
im2 = im2double(im2);

mask = [ones(1,145) linspace(1,0,19) zeros(1,145)];
%plot(mask)

mask = repmat(mask,309,1);
%imshow(mask);

im_blend = mask.*im1 + (1-mask).*im2;

figure(1),
subplot(1,3,1), imshow(im1),
subplot(1,3,2), imshow(im_blend),
subplot(1,3,3), imshow(im2)

