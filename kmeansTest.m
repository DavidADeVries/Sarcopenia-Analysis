 % load the data

 slice = '0015.dcm';
 
 mod1Path = '/data/projects/GJtube/Muscle Segmentation Project/Raw Data/MR_PELVIS_A/1201-AX-T1-hipsSIj-FS-C/';
 mod2Path = '/data/projects/GJtube/Muscle Segmentation Project/Raw Data/MR_PELVIS_A/801-AX-T1-hipsSIj/';
 mod3Path = '/data/projects/GJtube/Muscle Segmentation Project/Raw Data/MR_PELVIS_A/901-AX-T2-FS-hipsSIj/';
 
mod1 = double(dicomread(strcat(mod1Path, slice)));
mod2 = double(dicomread(strcat(mod2Path, slice)));
mod3 = double(dicomread(strcat(mod3Path, slice)));

dims1 = size(mod1);
dims2 = size(mod2);
dims3 = size(mod3);

maxDims = max([dims1;dims2;dims3]);

%scale up so all are max size. Scaled up to prevent data loss
mod1 = imresize(mod1, maxDims(1)/dims1(1));
mod2 = imresize(mod2, maxDims(1)/dims2(1));
mod3 = imresize(mod3, maxDims(1)/dims3(1));

figure(1);
imshow(mod1,[]);
figure(2);
imshow(mod2,[]);
figure(3);
imshow(mod3,[]);

%reshape into vectors
mod1Vec = reshape(mod1, maxDims(1)*maxDims(2), 1);
mod2Vec = reshape(mod2, maxDims(1)*maxDims(2), 1);
mod3Vec = reshape(mod3, maxDims(1)*maxDims(2), 1);

data = zeros(maxDims(1)*maxDims(2),3);

data(:,1) = mod1Vec;
data(:,2) = mod2Vec;
data(:,3) = mod3Vec;

%data = [mod2Vec; mod3Vec]; %[mod1Vec; mod2Vec; mod3vec];

[clusterIdX, clusterCentre] = kmeans(data, 4, 'Replicates',3);

labels = reshape(clusterIdX,maxDims(1),maxDims(2));

figure(4);
imshow(labels,[]);



 