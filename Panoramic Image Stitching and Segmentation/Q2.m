clc;
clear all;

img1 = readraw('Mosaic.raw', 450,600, true);
figure(1), imshow(uint8(img1));title('Original Image');
img1_pad = totalpad(img1,5);

filter = lawfilter();
img2 = zeros(454,604,25);

%Replicating the matrix along depth 25 times
for j = 1:25
    img2(:,:,j) = img1_pad;
end

img_conv = convmatrix(img2,filter);
wind_size = 55;
%% 

n = (wind_size - 1)/2;

m = wind_size;

for k = 1:25
    %y = zeros(450,600);
    img_sub = img_conv(:,:,k);
    img_pad = totalpad(img_sub,wind_size);
    height = size(img_pad,1);
    width = size(img_pad,2);
    for j = 1 + n : height - n 
       for i = 1 + n: width - n 
            row_top = j - n;
            row_bottom = j - n + m - 1;
            col_left = i - n;
            col_right = i - n + m - 1;
            sumsub = img_pad(row_top:row_bottom, col_left:col_right);
            temp = totalsum(sumsub,m);
            y(j - n ,i - n ) = temp;
       end
    end
    img_something(:,:,k) = y;
 end
%  img_sub = img_conv(:,:,2);
%  img_pad = totalpad(img_sub,wind_size);
%  y = zeros(450,600);
%     for j = 1 + n : height - n 
%        for i = 1 + n: width - n 
%             row_top = j - n;
%             row_bottom = j - n + m - 1;
%             col_left = i - n;
%             col_right = i - n + m - 1;
%             sumsub = img_pad(row_top:row_bottom, col_left:col_right);
%             temp = totalsum(sumsub,m);
%             y(j - n ,i - n ) = temp;
%        end
%     end
%     img_some(:,:,1) = y;
% d = avg(img_pad,wind_size);
% img_energy = reshape(d,[270000,1]);

% for j = 1:25
%     img_sub = img_conv(:,:,j);
%     img_pad = totalpad(img_sub,wind_size);
%     d = avg(img_pad,wind_size);
%     img_energy(:,:,j) = d;
% end

% %Averaging gives zeros
% for j = 1:25
%     img_energy(:,:,j) = avg(img_pad(:,:,j),wind_size);
% end

%% 
%img_energy = reshape(img_something,[270000,25]);
%%
% n1 = (29 - 1)/2;
% 
% m1 = 29;
% 
% for k = 1:25
%     %y = zeros(450,600);
%     img_sub = img_something(:,:,k);
%     img_pad = totalpad(img_sub,m1);
%     height = size(img_pad,1);
%     width = size(img_pad,2);
%     for j = 1 + n1 : height - n1 
%        for i = 1 + n1: width - n1 
%             row_top = j - n1;
%             row_bottom = j - n1 + m1 - 1;
%             col_left = i - n1;
%             col_right = i - n1 + m1 - 1;
%             sumsub = img_pad(row_top:row_bottom, col_left:col_right);
%             temp = totalsum(sumsub,m1);
%             y(j - n1 ,i - n1 ) = temp;
%        end
%     end
%     t(:,:,k) = y;
%  end
%% 
%imgenergy1 = reshape(img_energy,[270000,25]);
img_energynorm = img_something./img_something(:,:,1);
img_norm = img_energynorm(:,:,2:25);
img_normreshape = reshape(img_norm,[450*600,24]);

%Standardizing features

img_std = (img_normreshape - mean(img_normreshape))./std(img_normreshape);

%Performing kmeans
idx = kmeans((img_std),6,"MaxIter",100000);

idx_reshape = reshape(idx, 450, 600);

finimg = zeros(450, 600, 3);
red = [107,114,175,167,144,157];
green = [143, 99,128,57,147,189];
blue = [159, 107, 74, 32, 104, 204];

for j = 1:450
    for i = 1:600
        idx2 = idx_reshape(j, i);
        finimg(j, i, 1) = red(idx2);
        finimg(j, i, 2) = green(idx2);
        finimg(j, i, 3) = blue(idx2);
    end
end

figure(2),imshow(uint8(finimg)); title('Segmented Image');

%PCA for Feature Reduction

index_std = img_normreshape - mean(img_normreshape);

train_coeff = pca(index_std);

train = index_std*train_coeff(:,1:3);
train_std = (train - mean(train))./std(train);

idx_pca = kmeans(train_std,6,'MaxIter',10000000);

idx_pcareshape = reshape(idx_pca,[450,600]);

for j = 1:450
    for i = 1:600
        idx3 = idx_pcareshape(j, i);
        finimg_pca(j, i, 1) = red(idx3);
        finimg_pca(j, i, 2) = green(idx3);
        finimg_pca(j, i, 3) = blue(idx3);
    end
end

figure(3); imshow((finimg_pca)/255); title('Segmented Images using PCA');

