% Algorithm:
% For each pixel, calculate pixel intensity value to be: avg (blur radius)
% relative diff = pixel intensity / avg (mask radius)
% If relative diff < Threshold
%   intensity mult = (Ramp - MIN (Ramp, (Threshold - relative diff))) / Ramp
%   pixel intensity *= intensity mult
% 

function gr=cartoonlize(g,mask_radius,threshold,ramp)

g=im2double(g); % avoid  overflow

% appiattisce l'immagine blur
mask=fspecial('average',mask_radius);
g_new=imfilter(g,mask);
g_new=g./g_new;

mult=(ramp-min(ramp,(threshold-g_new)))/ramp;
ind=find(g_new<threshold);
gr=g;
gr(ind)=g(ind).*mult(ind);
end