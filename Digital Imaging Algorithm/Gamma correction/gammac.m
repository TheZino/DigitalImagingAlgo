%gamma correction for rgb images
    
function gimg = gammac(img, Y)

    H = rgb2hsv(img); %conversion RGB to HSV
    [N,M,C] = size(img);
    H = im2double(H);
    
    %Loop appling gamma correction on channel V
    for i = 1:N
        for j = 1:M
            H(i,j,3) = H(i,j,3)^Y;
        end
    end
    
    gimg = hsv2rgb(H); %conversion HSV to RGB for output
    
end