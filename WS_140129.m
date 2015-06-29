close all;clear all;

%% Load and display data
data_img = double(dicomread('/data/projects/GJtube/Muscle Segmentation Project/Raw Data/MR_SPINE_A/801-AX-T1-INF/0001.dcm'));
h_fig_1 = figure(1);
subplot(2,2,1)
imshow(data_img,[0 450]);
title('Select ROI');
% determine image size
[nx ny] = size(data_img);


%% Draw ROI and create mask
roi_A = imfreehand();
binImg = roi_A.createMask();
subplot(2,2,2)
R=data_img.*binImg
imshow(R,[0 350]); %creates ROI mask
title('Binary Mask of ROI');

%% Convert images into vectors for easy indexing
data_vec = reshape(data_img,[nx*ny 1]); %convert image to vector
mask_vec = reshape(binImg,[nx*ny 1]);  %convert mask to vector

mask_index = find(mask_vec == 1);%returns indicies of mask_vec where element=1
data_masked = data_vec(mask_index);

%% K-means magic
cluster1 = kmeans(data_masked,2);
%[silh,h]=silhouette(data_masked, cluster, 'city');

%% First Step: minimize cluster variance for high and low signal intensity
%i.e fat from muscle

% %Class 1: Low Signal
class_1.index = find(cluster1==1);
class_1_data = data_masked(class_1.index);
class_1.mean = mean(class_1_data);
class_1.min = min(class_1_data);
class_1.max = max(class_1_data);
class_1.median = median(class_1_data);

%Class 2: High Signal
class_2.index = find(cluster1==2);
class_2_data = data_masked(class_2.index);
class_2.mean = mean(class_2_data);
class_2.min = min(class_2_data);
class_2.max = max(class_2_data);
class_2.median = median(class_2_data);

%Mean 
mean1=(class_1.mean+class_2.mean)/2;

%% Histogram and Cut off's
figure();
bins = [0:0.5:250];
hist_out = hist(data_masked,bins);
hold on
stem(bins,hist_out, '.');
title('Histogram');
xlabel('Signal Intensity');
ylabel('Occurences');
line([mean1 mean1],[ 0 50000],'Color','r');    
axis([0 250 0 max(hist_out)]);

%% Second Step: applied to low signal cluster containing optimized muscle
% %Separates Dark pixels from very dark pixels

new_data=data_masked(data_masked<=mean1);
cluster2=kmeans(new_data,2);

%Class 3: Very Dark
class_3.index = find(cluster2==1);
class_3.data = new_data(class_3.index);
class_3.mean = mean(class_3.data);
class_3.min = min(class_3.data);
class_3.max = max(class_3.data);
class_3.median = median(class_3.data);

%Class 4: Dark
class_4.index = find(cluster2==2);
class_4.data = new_data(class_4.index);
class_4.mean = mean(class_4.data);
class_4.min = min(class_4.data);
class_4.max = max(class_4.data);
class_4.median = median(class_4.data);

%Mean 
mean2=(class_3.mean+class_4.mean)/2;
hold on;
line([mean2 mean2],[ 0 50000],'Color','g'); 

%% Highlight all pixels that are a part of the high intensity non-contractile
%component after first clustering
% R(R>=mean1)=600;
dims = size(R);
R_vec = reshape(R,[dims(1)*dims(2) 1]);      %reshapes all elements of R into a column vector
index_Non_contract = find(R_vec>90); %set a threshold amount and find all indicies that have a pixel reading of greater than 90    
% 
R_colour_vec = repmat( R_vec / max(R_vec), [1 3]); %normalizes data and reshapes into 1 row and 3 columns
R_colour_vec(index_Non_contract, 1) = 0;
R_colour_vec(index_Non_contract, 2) = 1;    %highlight high intensity pixels in green
R_colour_vec(index_Non_contract, 3) = 0;

R_colour = reshape(R_colour_vec, [dims(1) dims(2) 3]);

figure(3);
subplot(1,2,1),imshow(R_colour);
title('1st Clustering: High intensity voxels highlighted in green');
 
index_low = find(R_vec<=50 & R_vec >0);
R_colour_vec(index_low, 1) = 1;
R_colour_vec(index_low, 2) = 0;
R_colour_vec(index_low, 3) = 0;
% 
% R_colour = reshape(R_colour_vec, [512 512 3]);
% subplot(1,2,1),
% imshow(R(135:356,300:500,:),[]);
% subplot(1,2,2), 
% imshow(R_colour(135:356,300:500,:));
% title('2nd Clustering: Low intensity voxels highlighted in red');
% 
% 
% 
% [testestse, C] = kmeans(data_img(:),3,'start',[10 ;75 ;180]);
% C
% index_1 = find(testestse==1);
% index_3 = find(testestse==3);
% index_2 = find(testestse==2);
% max_1 = max(data_img(index_1))
% max_2 = max(data_img(index_2))
% max_3 = max(data_img(index_3))
% 
% figure(4),
% hist(data_img(find(data_img(:)>5)),[0:5:250]);
% 
% line([max_1 max_1], [0 10000]);
% line([max_2 max_2], [0 10000]);
% line([max_3 max_3], [0 10000]);


