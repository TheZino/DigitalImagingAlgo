%% Pyramid Blending
clear all
clc

im2 = im2double(rgb2gray(imread('hand.bmp')));
im1 = im2double(rgb2gray(imread('eye.bmp')));

%% costruzione della piramide gaussiana a 2 livelli su im1
pirG1 = {};
pirG1{1,1} = impyramid(im1,'reduce');
pirG1{1,2} = impyramid(pirG1{1,1},'reduce');

%% costruzione della piramide gaussiana a 2 livelli su im2
pirG2 = {};
pirG2{1,1} = impyramid(im2,'reduce');
pirG2{1,2} = impyramid(pirG2{1,1},'reduce');

%% maschera di blend
% mask = zeros(size(im1));
% mask(:,1:210,:) = 1;

% mask = imfilter(mask, fspecial('gaussian', 10, 5), 'same', 'replicate');

mask = imread('mask.bmp');
mask = im2double(mask);

pirGm = {};
pirGm{1,1} = impyramid(mask,'reduce');
pirGm{1,2} = impyramid(pirGm{1,1},'reduce');

%% piramide laplaciana immagine 1
pirL1 = {};
pirL1{1,1} = im1 - imresize(pirG1{1,1}, [size(im1,1) size(im1,2)]);
pirL1{1,2} = pirG1{1,1} - imresize(pirG1{1,2}, ...
                [size(pirG1{1,1},1), size(pirG1{1,1},2)]);
pirL1{1,3} = pirG1{1,2};

% Visualizzazione piramide
% for ii = 1:3
%     figure(ii), clf
%     imshow(pirL1{1,ii}(:,:,2),[])
% end

%% piramide laplaciana immagine 2
pirL2 = {};
pirL2{1,1} = im2 - imresize(pirG2{1,1}, [size(im2,1) size(im2,2)]);
pirL2{1,2} = pirG2{1,1} - imresize(pirG2{1,2}, ...
                [size(pirG2{1,1},1), size(pirG2{1,1},2)]);
pirL2{1,3} = pirG2{1,2};

% Visualizzazione piramide
% for ii = 1:3
%     figure(ii), clf
%     imshow(pirL2{1,ii}(:,:,2),[])
% end

%% blend delle piramidi
pirB = {};
pirB{1,1} = mask.*pirL1{1,1} + (1-mask).*pirL2{1,1};
pirB{1,2} = pirGm{1,1}.*pirL1{1,2} + (1-pirGm{1,1}).*pirL2{1,2};
pirB{1,3} = pirGm{1,2}.*pirL1{1,3} + (1-pirGm{1,2}).*pirL2{1,3};

% Visualizzazione piramide
% for ii = 1:3
%     figure(ii), clf
%     imshow(pirB{1,ii}(:,:,2),[])
% end

%% Image blending
out = pirB{1,2} + imresize(pirB{1,3}, [size(pirB{1,2},1), size(pirB{1,2},2)]);
out = pirB{1,1} + imresize(out, [size(pirB{1,1},1), size(pirB{1,1},2)]);

imshow(out);