% Wrapper for CPMC


% May want to stratify the img_names
% if we're doing something in parallel

% Remove this path cuz we want to use the actual toolbox
rmpath(genpath('~/Documents/MATLAB/toolbox_ext/cpmc_release1/external_code/vlfeats_bak/'));


procPath = '/afs/ee.cooper.edu/user/l/i/li14/AFSdrop/CATSnDOGS/processed/';
exp_dir = '/afs/ee.cooper.edu/user/l/i/li14/AFSdrop/CATSnDOGS/processed/data/';
savePath = fullfile(procPath,'savedMasks/');

data.imPath = strcat(exp_dir,'JPEGImages/');
data.dir = dir(fullfile(strcat(data.imPath,'*.jpg')));
data.cell = struct2cell(data.dir);
data.file_names = data.cell(1,:)';
data.files = strcat(data.imPath,data.cell(1,:))';
data.n = numel(data.files);


for ii = 1:data.n
    tic
img_name = data.file_names{ii};
% strip .jpg
img_name = img_name(1:end-4);

disp(strcat(img_name,': start'))

if ~exist(strcat(procPath,'savedMasks/',img_name,'.mat'),'file')
    my_cpmc(img_name,exp_dir,savePath)
else
    disp(strcat(num2str(img_name),': skipped'))
end

    fprintf('---[[[%d took %g sec]]]---\n',ii,toc)

end
