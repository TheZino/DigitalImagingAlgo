% Adaptive gamma correction for 0-255 bit images.

function out = adapt_gamma(image, filterd, sigma)
    
    if nargin < 2
        filterd = 25;
        sigma = 5;
    end

    % Preparig image    
    img = im2double(image);
    img = rgb2ycbcr(img);
    
    chY = img(:,:,1);
    
    % Building mask
    mask = chY;      % B/W, channel Y from image in YCbCr color space
    
    F = fspecial('gaussian',filterd, sigma); % Fspecial for building a gaussian filter
                                   
    mask = imfilter(mask, F,'same', 'replicate');   % Smoothing 
    mask = ones(size(mask)) - mask;                 % Inversion
    
    % Appling gamma correction
    
    newY = chY.^(2.^((0.5-mask)/0.5));

    img(:,:,1) = newY;
    out = ycbcr2rgb(img);
    
    
    % results
    figure(1),
    subplot(1,2,1) , imshow(image), title('original'),
    subplot(1,2,2) , imshow(out), title('gamma applied')
    
    

end