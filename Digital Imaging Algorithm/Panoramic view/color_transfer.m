% Color transfer algorithm

function out = color_tansfer(image, model)
   
    img = im2double(image);
    mod = im2double(model);
    
    img = rgb2ycbcr(img);
    mod = rgb2ycbcr(mod);
    
    IMG = reshape(img,[],3); % transform into a matrice with 3 column
    MOD = reshape(mod,[],3); 
    
    stat1  = [mean(IMG) std(IMG)];
    stat2  = [mean(MOD) std(MOD)];
    
    img(:,:,1) = (img(:,:,1) - stat1(1,1))/stat1(1,4);
    img(:,:,2) = (img(:,:,2) - stat1(1,2))/stat1(1,5);
    img(:,:,3) = (img(:,:,3) - stat1(1,3))/stat1(1,6);
    
    img(:,:,1) = (img(:,:,1)*stat2(1,4))+stat2(1,1);
    img(:,:,2) = (img(:,:,2)*stat2(1,5))+stat2(1,2);
    img(:,:,3) = (img(:,:,3)*stat2(1,6))+stat2(1,3);
    
    out = ycbcr2rgb(img);
    
    %results
    figure(1)
    subplot(1,3,1), imshow(image),
    subplot(1,3,2), imshow(model),
    subplot(1,3,3), imshow(out)
end