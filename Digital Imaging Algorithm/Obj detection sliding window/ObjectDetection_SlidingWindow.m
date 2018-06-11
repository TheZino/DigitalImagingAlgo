%% Object Detection with sliding window
clear all
clc

%% TRAINING
%% variabili
pointPositions = [];    %posizione dei punti d'interesse di ciascuna immagine

features = [];          %lista delle features
labels = [];            %collezione classe-immagine

K = 100; % # delleclassi per k-means
BOW_tr = [];
labels_tr = []; 


%% Estrazione features da immagini di test

for ii = 5:5:35
    for jj = 5:5:95
        pointPositions = [pointPositions; ii jj];
    end
end

% immagini negative

for nimage = 0:100

    im = imread(['./TrainImages/neg-' num2str(nimage) '.pgm']);
    im = im2double(im);
    
    % estrazione features
    % keypoints = detectSURFFeatures(im);
    [im_features ~] = extractFeatures(im, pointPositions, 'Method', 'SURF');
    
    features = [features; im_features];
    labels = [labels; zeros(size(im_features, 1), 1) repmat(nimage, size(im_features, 1), 1)];
    
end

% immagini positive
for nimage = 0:100

    im = imread(['./TrainImages/pos-' num2str(nimage) '.pgm']);
    im = im2double(im);
    
    % estrazione features
    %keypoints = detectSURFFeatures(im);
    [im_features ~] = extractFeatures(im, pointPositions, 'Method', 'SURF');
    
    features = [features; im_features];
    labels = [labels; ones(size(im_features, 1), 1) repmat(nimage, size(im_features, 1), 1)];
    
end

%% Vocabolario

[IDX, C] = kmeans(features, K); % kmeans: IDX id, C centroidi

%% Costruzione istogrammi delle firme

for class = 0:1
    for nimage = 0:100
        % Ricerca degli indici dell'immagine corrente nel ciclo per
        % ottenere velocemente le sue 25 features.
        u = find(labels(:,1) == class & labels(:,2) == nimage);
        imfeaturesIDX = IDX(u);
        H = hist(imfeaturesIDX, 1:K);
        H = H./sum(H);
        % Vettori che associano istogrammi - classe
        BOW_tr = [BOW_tr; H];
        labels_tr = [labels_tr; class];
    end 
end

%% TEST
%% Variabili
new_labels = [];

%% Scansione immagine

imsT = dir('./TestImages/test*.pgm');

for nim = 1:size(imsT,1)
    im = imread(['./TestImages/' imsT(nim, 1).name]);
    
    for dx = 1:5:size(im,2)-100-1
        for dy = 1:5:size(im,1)-40-1
            windows = im(dy:dy+40-1,dx:dx+100-1);
            % estrazione features
            [im_features, ~] = extractFeatures(im, pointPositions, 'Method', 'SURF');
            D = pdist2(im_features, C);
            [~, words] = min(D, [], 2);
            H = hist(words, 1:K);
            H = H./sum(H);
            DH = pdist2(H, BOW_tr);
            u = find(DH == min(DH));
            predictedClass = labels_tr(u(1));
            if predictedClass == 1 % se è una macchina disegno la box
                im = insertObjectAnnotation(im, 'rectangle', [dx dy 100 40], 'car');
                imshow(im);
            end
        end
    end
end