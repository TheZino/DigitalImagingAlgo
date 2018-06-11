%% Object Detection
clear all
clc

boxImage = imread('stapleremover.jpg');
sceneImage = imread('clutteredDesk.jpg');

%% detection dei punti d'interesse
boxPoints = detectSURFFeatures(boxImage);
scenePoints = detectSURFFeatures(sceneImage);

%% visualizzazione dei punti con attivazione maggiore
figure(1), imshow(boxImage)
hold on
plot(selectStrongest(boxPoints, 100)), hold off

figure(2), imshow(sceneImage)
hold on
plot(selectStrongest(scenePoints, 100)), hold off
clc

%% estrazione features
[boxFeatures, boxPoints] = extractFeatures(boxImage,boxPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage,scenePoints);

%% match tra fatures
boxPairs = matchFeatures(boxFeatures,sceneFeatures);

%% visualizzazione match
matchedBoxPoints = boxPoints(boxPairs(:,1),:);
matchedScenePoints = scenePoints(boxPairs(:,2),:);

figure
   showMatchedFeatures(boxImage, sceneImage, ...
       matchedBoxPoints, matchedScenePoints, 'montage')
clc
   
%% pulizia dei match
[tform, inlinerBoxPoints,inlinerScenePoints] = ...
    estimateGeometricTransform(matchedBoxPoints,matchedScenePoints, ...
    'affine');

figure
   showMatchedFeatures(boxImage, sceneImage, ...
       inlinerBoxPoints, inlinerScenePoints, 'montage')
clc
   
%% bounding box
boxPoly=[1 1;
    size(boxImage, 2) 1;
    size(boxImage, 2) size(boxImage, 1);
    1 size(boxImage, 1);
    1 1];

newBoxPoly = transformPointsForward(tform, boxPoly);

figure
imshow(sceneImage)
hold on
line(newBoxPoly(:,1), newBoxPoly(:,2),'Color','y');
hold off
clc

%% indentificazione elefante
eleImage = imread('elephant.jpg');

%% detecrion dei punti d'interesse
elePoints = detectSURFFeatures(eleImage);

figure, imshow(eleImage)
hold on
plot(selectStrongest(elePoints, 100)), hold off

%% estrazione features
[eleFeatures, elePoints] = extractFeatures(eleImage,elePoints);

%% matching features
elePairs = matchFeatures(eleFeatures,sceneFeatures);

%% visualizzazione match
matchedElePoints = elePoints(elePairs(:,1),:);
matchedScenePoints = scenePoints(elePairs(:,2),:);

figure
   showMatchedFeatures(eleImage, sceneImage, ...
       matchedElePoints, matchedScenePoints, 'montage')
clc
   
%% pulizia dei match
[tform, inlinerElePoints,inlinerScenePoints] = ...
    estimateGeometricTransform(matchedElePoints,matchedScenePoints, ...
    'affine');

figure
   showMatchedFeatures(eleImage, sceneImage, ...
       inlinerElePoints, inlinerScenePoints, 'montage')
clc

%% bounding box
boxPoly=[1 1;
    size(eleImage, 2) 1;
    size(eleImage, 2) size(eleImage, 1);
    1 size(eleImage, 1);
    1 1];

newBoxPoly = transformPointsForward(tform, boxPoly);

figure
imshow(sceneImage)
hold on
line(newBoxPoly(:,1), newBoxPoly(:,2),'Color','g');
hold off
clc