% -------------------------------
% Jason Tam & David Li
% MaKeene Learning
% Cats vs Dogs
% -------------------------------

%% 
addpath('./features/');
data.source = 'data';

data.path = fullfile(getPath(data.source),'test1');
data.annotations = fullfile(getPath,'processed','savedMasks');
data.dir = dir(fullfile(data.path,'*.jpg'));
data.cell = struct2cell(data.dir);
data.names = data.cell(1,:);
data.filepaths = fullfile(data.path,data.names);
data.n = numel(data.names);
%%

saveName = 'TEST_SET_FEATURES';
savePath = strcat(getPath,saveName,'.mat');

%%

classes = {
    'cat'   % 1
    'dog'	% 2
};
nClasses = numel(classes);

nFeatures_global = 43;
nFeatures_mask = 186;

%%

% Preallocate
x_g = zeros(data.n,nFeatures_global);
x_m = zeros(data.n,nFeatures_mask);
% x_ii = zeros(1,nFeatures);
names = cell(data.n,1);

parfor ii = 1:data.n
    tic
    [~,name,~] = fileparts(data.names{ii});
    names{ii} = name;
    fprintf('#%d \t %s\n',ii,name)

    % Read Image
    I = imread(data.filepaths{ii});
    
    % Read Mask if exists
    maskPath = fullfile(data.annotations,strcat(name,'.mat'));
    if exist(maskPath,'file')
        loadVar = load(maskPath);
        % Choose 1st mask (best score)
        BW = loadVar.save_masks(:,:,1);
        BW = imfill(BW,'holes');
    else
        BW = ones([size(I,1) size(I,2)]);
    end
    % Apply Mask
    I_m = I.*uint8(repmat(BW,[1 1 size(I,3)]));

    % Grayscale
    if size(I_m,3)>1
        I_g = rgb2gray(I_m);
    else
        I_g = I_m;
        I = repmat(I,[1 1 3]);
        I_m = repmat(I_m,[1 1 3]);
    end

    % Boundary
    if any(BW(:))
        B = bwboundaries(BW,'noholes');
        C = B{1};   % 'contour'
    else
        C = [0 0];
    end

    %% Extract Features
    % 43
    x_ii_Global = getGlobalFeatures(I, I_g);
    % 186
    x_ii_Mask = getMaskedFeatures(I_m, I_g, BW, C);

%     x_ii = [x_Global x_Mask];

    fprintf('Image Done Time: %f \t %s\n',toc,name)
    % Move iith feature vec to combined feature vec
    x_g(ii,:) = x_ii_Global;
    x_m(ii,:) = x_ii_Mask;
end

save(savePath,'x_g','x_m','names');

disp('done doing crap');




