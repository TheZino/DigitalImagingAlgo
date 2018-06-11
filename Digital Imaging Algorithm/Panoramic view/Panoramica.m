%% Panoramica
clear all;
clc

%% Variabili

centerImageC = imread('buildingcenter_r.jpg');
leftImageC = imread('buildingleft_r.jpg');
rightImageC = imread('buildingright_r.jpg');

centerImageC = im2double(centerImageC);
leftImageC = im2double(leftImageC);
rightImageC = im2double(rightImageC);

centerImage = rgb2gray(centerImageC);
leftImage = rgb2gray(leftImageC);
rightImage = rgb2gray(rightImageC);

centerImage = im2double(centerImage);
leftImage = im2double(leftImage);
rightImage = im2double(rightImage);

%% Detection dei punti notevoli

centerPoints = detectSURFFeatures(centerImage);
leftPoints = detectSURFFeatures(leftImage);
rightPoints = detectSURFFeatures(rightImage);

%% Estrazione features

[centerImFeatures, centerPoints] = extractFeatures(centerImage, centerPoints);
[leftImFeatures, leftPoints] = extractFeatures(leftImage, leftPoints);
[rightImFeatures, rightPoints] = extractFeatures(rightImage, rightPoints);

%% Match tra immagine left e center

centerLeftPairs = matchFeatures(centerImFeatures, leftImFeatures);
centerRightPairs = matchFeatures(centerImFeatures, rightImFeatures);

matchedCenterLeftPoints = centerPoints(centerLeftPairs(:,1),:);
matchedLeftPoints = leftPoints(centerLeftPairs(:,2),:);

matchedCenterRightPoints = centerPoints(centerRightPairs(:,1),:);
matchedRightPoints = rightPoints(centerRightPairs(:,2),:);

%% Trasformazione left -> center

[tform_L2C, inlinerLeft, inlinerCenterLeft] = ...
    estimateGeometricTransform(matchedLeftPoints, matchedCenterLeftPoints ...
    , 'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);

[tform_R2C, inlinerRight, inlinerCenterRight] = ...
    estimateGeometricTransform(matchedRightPoints, matchedCenterRightPoints ...
    , 'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);

%% Preparazione Panoramica LC

s = size(leftImage);
[xlimL, ylimL] = outputLimits(tform_L2C,[1, s(2)], [1,s(1)]);

xMin = min([1; xlimL(:)]);
xMax = max([s(2); xlimL(:)]);
yMin = min([1; ylimL(:)]);
yMax = max([s(1); ylimL(:)]);

% dimensione del panorama contenente
width = round(xMax-xMin);
height = round(yMax-yMin);

% creazione riderimenti 2D
xLimits = [xMin xMax];
yLimits = [yMin yMax];

panoramaView = imref2d([height width], xLimits, yLimits);

% trasformazione leftImage

leftImageC = color_transfer(leftImageC, centerImageC);

newLeftImage = imwarp(leftImageC, tform_L2C, 'OutputView', panoramaView);
maskL = imwarp(true(s(1), s(2)), tform_L2C, 'OutputView', panoramaView);

% figure, imshow(newLeftImage)
% figure, imshow(maskL)
% clc

% trasformazione centerimage
tform_C2C = tform_L2C;
tform_C2C.T = eye(3);

newCenterImage = imwarp(centerImageC, tform_C2C, 'OutputView', panoramaView);
maskC = imwarp(true(s(1), s(2)), tform_C2C, 'OutputView', panoramaView);

% figure, imshow(newCenterImage)
% figure, imshow(maskC)
% figure, imshowpair(newCenterImage, newLeftImage)

%% Preparazione Panoramica PR

s = size(rightImage);
[xlimR, ylimR] = outputLimits(tform_R2C,[1, s(2)], [1,s(1)]);

xMin = min([xLimits(1); xlimR(:)]);
xMax = max([xLimits(2); xlimR(:)]);
yMin = min([yLimits(1); ylimR(:)]);
yMax = max([yLimits(2); ylimR(:)]);

% dimensione del panorama contenente
width = round(xMax-xMin);
height = round(yMax-yMin);

% creazione riderimenti 2D
xLimits = [xMin xMax];
yLimits = [yMin yMax];

panoramaView = imref2d([height width], xLimits, yLimits);

% trasformazione leftImage

rightImageC = color_transfer(rightImageC, centerImageC);

newRightImage = imwarp(rightImageC, tform_R2C, 'OutputView', panoramaView);
maskR = imwarp(true(s(1), s(2)), tform_R2C, 'OutputView', panoramaView);

newLeftImage = imwarp(leftImageC, tform_L2C, 'OutputView', panoramaView);
maskL = imwarp(true(s(1), s(2)), tform_L2C, 'OutputView', panoramaView);

newCenterImage = imwarp(centerImageC, tform_C2C, 'OutputView', panoramaView);
maskC = imwarp(true(s(1), s(2)), tform_C2C, 'OutputView', panoramaView);

figure, imshow(newLeftImage)
figure, imshow(maskL)
figure, imshow(newRightImage)
figure, imshow(maskR)
figure, imshow(newCenterImage)
figure, imshow(maskC)
figure, imshowpair(newCenterImage, newLeftImage)
figure, imshowpair(newCenterImage, newRightImage)

%% Concatenazione immagini

out1 = pyramid(im2double(rgb2gray(newCenterImage)),im2double(rgb2gray(newLeftImage)),...
    im2double(maskC),im2double(maskL));

out2 = pyramid(im2double(rgb2gray(newRightImage)), im2double(rgb2gray(newCenterImage)),...
    im2double(maskR),im2double(maskC));


out = pyramid(out1, out2);

imshow(out)
