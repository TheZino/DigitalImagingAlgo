%% Feature extraction and Image Classification
clear all 
clc

%% TRAINING
%% Variabili
pointPositions = [];    %posizione dei punti d'interesse di ciascuna immagine

features = [];          %lista delle features
labels = [];            %collezione classe-immagine

K = 100;
BOW_tr = [];
labels_tr = []; 

%% Estrazione di 25 punti d'interesse da utilizzare nel K-means
%  per immagine 500x500
for ii = 50:100:450
    for jj = 50:100:450
        pointPositions = [pointPositions; ii jj];
    end
end

%% Scorrimento delle prime 10 immagini di ciascuna classe ed estrazione fetaures
tic
for class = 0:9
    for nimage = 0:9
        disp([num2str(class) '-' num2str(nimage)]);
        im = imread(['./simplicityDB/image.orig/' num2str(100*class+nimage) '.jpg']);
        im = im2double(im);
        im = imresize(im, [500 500]);
        im = rgb2gray(im);
        % Estrazione delle features dall'immagine
        [imfeatures, ~] = extractFeatures(im, pointPositions, 'Method', 'SURF');
        features = [features; imfeatures];
        labels = [labels; repmat(class, size(imfeatures, 1), 1) ...
                    repmat(nimage, size(imfeatures, 1), 1)];
    end
end
toc

%% Creazione vocabolario
tic
[IDX, C] = kmeans(features, K); % kmeans: IDX id, C centroidi
toc

%% Istogrammi delle firme
for class = 0:9
    for nimage = 0:9
        % Ricerca degli indici dell'immagine corrente nel ciclo per
        % ottenere velocemente le sue 25 features.
        u = find(labels(:,1) == class & labels(:,2) == nimage);
        imfeaturesIDX = IDX(u);
        H = hist(imfeaturesIDX, 1:K);
        H = H./sum(H);
        BOW_tr = [BOW_tr; H];
        labels_tr = [labels_tr; class];
    end 
end

%% TEST
%% Variabili
new_labels = [];

%% Estrazione features da immagini di test
tic
for class = 0:9
    for nimage = 10:99
        %disp([num2str(class) '-' num2str(nimage)]);
        im = imread(['./simplicityDB/image.orig/' num2str(100*class+nimage) '.jpg']);
        im = im2double(im);
        im = imresize(im, [500 500]);
        im = rgb2gray(im);
        % Estrazione delle features dall'immagine
        [new_imfeatures, ~] = extractFeatures(im, pointPositions, 'Method', 'SURF');
        [~, I] = pdist2(C, new_imfeatures, 'minkowski', 'smallest', 1);
        % istogramma dell'immagine
        new_h = hist(I, 1:K);
        new_h = new_h./sum(new_h);
        % distanza tra istogrammi
        [~, label_index] = pdist2(BOW_tr, new_h, 'minkowski', 'smallest', 1);
        predicted_class = labels_tr(label_index);
        new_labels = [new_labels; class predicted_class];
        
    end
end
toc

%% Matrice di confusione
CM = confusionmat(new_labels(:,1), new_labels(:,2));
CM = CM./(repmat(sum(CM,2), 1, size(CM,2)));
accuracy = mean(diag(CM));