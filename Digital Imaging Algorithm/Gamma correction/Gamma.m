im1 = imread('overexposed2.jpg');

gvalue = 3;

img = im2double(im1).^(gvalue);

figure(1),
subplot(2,2,1), imshow(im1)
subplot(2,2,3), imshow(img),
subplot(2,2,2), imhist(im1(:,:,2)),
subplot(2,2,4), imhist(img(:,:,2))