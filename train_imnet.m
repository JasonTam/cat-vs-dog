% -------------------------------
% Jason Tam & David Li
% MaKeene Learning
% Cats vs Dogs
% -------------------------------

%% 

addpath('./features/');

data.source = 'imagenet';
switch data.source
    case 'data'
        data.path = strcat(getPath,'train/');     % Train path for origset 
    case 'imagenet'
        data.path = fullfile(getPath(data.source),'images');
        data.annoPath = fullfile(getPath(data.source),'annotations');
        
        fNames = dir(data.path); fNames = struct2cell(fNames(3:end));
        data.fNames = fNames(1,:);
        
        for ii = 1:numel(data.fNames)
            fileList = getAllFiles(fullfile(data.path,data.fNames{ii}));
            fileList = pruneTypes(fileList,'JPEG');
            
%             data.dir{ii} = dir(fullfile(data.path,data.fNames{ii},'*.jpg'));
%             data.cell{ii} = struct2cell(data.dir{ii});
            data.fullfilepaths{ii} = fileList;
%             data.files{ii} = fullfile(data.path,data.names{ii})';
            data.n{ii} = numel(data.fullfilepaths{ii});
        end
        
    case 'oxford'
        data.path = fullfile(getPath(data.source),'images');
        data.annoPath = fullfile(getPath(data.source),'annotations');
        data.triPath = fullfile(data.annoPath,'trimaps');
        
        fNames = dir(data.path); fNames = struct2cell(fNames(3:end));
        data.fNames = fNames(1,:);
        
        for ii = 1:numel(data.fNames)
            data.dir{ii} = dir(fullfile(data.path,data.fNames{ii},'*.jpg'));
            data.cell{ii} = struct2cell(data.dir{ii});
            data.names{ii} = data.cell{ii}(1,:);
%             data.files{ii} = fullfile(data.path,data.names{ii})';
            data.n{ii} = numel(data.names{ii});
        end
end

saveName = 'IMNET_FEATURES_BIG';
savePath = strcat(getPath,saveName,'.mat');

%%

classes = {
    'cat'   % 1
    'dog'	% 2
};
nClasses = numel(classes);

nFeatures = 43;

%%
x = cell(numel(data.fNames),1); y = x;
save(savePath,'x','y');
for folder = 1:numel(data.fNames)
%     Preallocate
x{folder} = zeros(data.n{folder},nFeatures);
x_ii = nan(1,nFeatures);
y{folder} = zeros(data.n{folder},1);

y_slice = zeros(data.n{folder},1);
x_slice = zeros(data.n{folder},nFeatures);
    parfor ii = 1:data.n{folder}
        try
            tic
            [~,name,~] = fileparts(data.fullfilepaths{folder}{ii});    % Display current file
            fprintf('Folder: %s \t #%d \t %s\n',classes{folder},ii,name)
            % Set up truth
    %         y(ii) = find(strcmp(data.files{ii}(numel(data.path)+1:numel(data.path)+3),classes));
    %         y{folder}(ii) = folder;
            y_slice(ii) = folder;

            % Read Image
            I = imread(data.fullfilepaths{folder}{ii});

            % Grayscale
            if size(I,3)>1
                I_g = rgb2gray(I);
            else
                I_g = I;
                I = repmat(I,[1 1 3]);
            end

            %% Extract Features
            x_ii = getGlobalFeatures(I, I_g);

            fprintf('Time: %f \t %s\n',toc,name)
            % Move iith feature vec to combined feature vec
    %         x{folder}(ii,:) = x_ii;
            x_slice(ii,:) = x_ii;

    %         save(savePath,'x','y','-append');
        catch
%             do nothing, just skip
        end

    end
    y{folder} = y_slice;
    x{folder} = x_slice;
    save(savePath,'x','y','-append');
end

disp('done with crap');

if 0
    %% Combine x, y
    xx = cell2mat(x);
    xx(isnan(xx)) = 0;
    xx(isinf(xx)) = 0;
    yy = cell2mat(y);
    %%
    dataSet = prtDataSetClass(xx,yy);
    dataSet = dataSet.setClassNames(classes);
    % plot(dataSet);



    %% PreProcessing
    % % % 
    if 0
        pca = prtPreProcPca;      % Create a prtPreProcPca object
        pca.nComponents = 3;      % nComponents is a field of prtPreProcPca objects
        pca = pca.train(dataSet); % Outputs a pca object with pcaVectors set
        pca = pca.run(dataSet); 
        % 
        % plot the data.
        % figure(1); plot(dataSet);
        % figure(2); plot(pca);
    end

    zmuv = prtPreProcZmuv;
    zmuv = zmuv.train(dataSet); 
    dsPreProc = zmuv.run(dataSet);


    %% Run Classifier
    tic
    % Classifier = prtClassMap;
    % Classifier = prtClassBinaryToMaryOneVsAll;
    % Classifier = prtClassMatlabTreeBagger;
    % Classifier = prtClassMatlabNnet;
    % Classifier = prtClassTreeBaggingCap;
    % Classifier.baseClassifier = prtClassAdaBoost;         
    % Classifier.baseClassifier = prtClassSvm;
    % Classifier.baseClassifier = prtClassLibSvm;
    % Classifier.baseClassifier = prtClassRvm;

    % Classifier.baseClassifier = prtClassLogisticDiscriminant;

    % Classifier = Classifier.train(pca);
    Classifier = prtClassLibSvm;

    % Classifier = prtClassAdaBoost;
    % % Classifier = prtClassRvm;
    Classifier = Classifier.train(dsPreProc);
    toc
    % plot(Classifier)

    %% Validation
    % try computing 3 classifiers every time
    % truth = dsPca.getTargets; %the true class labels
    truth = dataSet.getTargets; %the true class labels
    yOutKfolds = Classifier.kfolds(dsPreProc,5); %10-Fold cross-validation
    %% Analyze Classifier


    [pf,pd] = prtScoreRoc(yOutKfolds);
    h = plot(pf,pd);

    %We need to parse the output of the KNN classifier to turn vote counts into
    %class guesses - for each observation, our guess is the column with the
    %most votes!
    % [nVotes,guess] = max(yOutKfolds.getObservations,[],2);
    guess = 1+double(yOutKfolds.getObservations>0.7);

    %% Plot
    subplot(1,1,1); %don't plot in the last figure window.
    confusion = prtScoreConfusionMatrix(guess,truth,dataSet.uniqueClasses,dataSet.getClassNames);
    prtScoreConfusionMatrix(guess,truth,dataSet.uniqueClasses,dataSet.getClassNames);
    title('Classification Confusion Matrix');

    fprintf('Perc Correct: %g\n', sum(diag(confusion))/sum(confusion(:)));

    %%


    end

