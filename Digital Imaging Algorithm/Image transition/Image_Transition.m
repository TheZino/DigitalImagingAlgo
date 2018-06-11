im1 = imread('lontra.jpg');
im2 = imread('wallhaven-400940.jpg');

im1 = imresize(im1 , 0.4);

s1 = size(im1);
s2 = size(im2);

im2 = imresize(im2, s1(1:2));

im1 = im2double(im1);
im2 = im2double(im2);

%im3 = im1*0.5 + im2*0.5;

%% Transizione

% for w=0:0.01:1
%     im3 = (1-w)*im1 + w*im2;
%     figure(2), clf, imshow(im3), drawnow
% end

%% Transizione sx to dx

% for c=1:s1(2)
%     im3 = im1;
%     im3(:,1:c,:) = im2(:,1:c,:);
%     figure(2), clf, imshow(im3), drawnow
% end

%% Transizione diagonale

% for c=1:s1(2)
%     im3 = im1;
%     if (c < s1(1) & c<s1(2))
%         im3(1:c,1:c,:) = im2(1:c,1:c,:);
%     elseif(c > s1(1) & c<s1(2))
%         im3(:,1:c,:) = im2(:,1:c,:);
%     else
%         im3(1:c,:,:) = im2(1:c,:,:);        
%     end
%     figure(2), clf, imshow(im3), drawnow
% end

for p=0:0.01:1
    im3 = im1;
    im3(1:p*s1(1),1:p*s1(2),:) = im2(1:p*s1(1),1:p*s1(2),:);
    figure(2), clf, imshow(im3), drawnow
end