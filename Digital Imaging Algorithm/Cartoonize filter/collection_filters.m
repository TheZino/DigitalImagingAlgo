%% Test per l'elaborazione delle foto su Android
clear all;
clc;
%% Comic
 % Cartoon algorithm  ( Courtesy of gimp )
 % -----------------
 % Mask radius = radius of pixel neighborhood for intensity comparison
 % Threshold   = relative intensity difference which will result in darkening
 % Ramp        = amount of relative intensity difference before total black
 % Blur radius = mask radius / 3.0
 
im = imread('girl.jpg');

mask_radius=30; % max 100
threshold=1;    % max 1.1
ramp=0.3;       % min 0.1


% in base se l'immagine è in rgb o grayscale esegue il cartoonize su uno o
% sui tre lvl colore
if ndims(im) == 3 
        % rgb 
        r=im(:,:,1);
        g=im(:,:,2);
        b=im(:,:,3);
        rr=cartoonlize(r,mask_radius,threshold,ramp);
        gr=cartoonlize(g,mask_radius,threshold,ramp);
        br=cartoonlize(b,mask_radius,threshold,ramp);
        imr=cat(3,rr,gr,br);
else
        %grayscale
        imr=cartoonlize(im,mask_radius,threshold,ramp);
end

figure 
subplot (1,2,1), imshow(imr);
subplot (1,2,2), imshow(im);

imwrite(imr, 'cartoon.jpg');
