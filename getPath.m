function [ thePath ] = getPath( whichPath )
%GETPATH Returns certain hardcoded paths
%   'data' : the base data directory
%   'imagenet' : the imagenet external database

if nargin<1; whichPath = 'data'; end;

base = '/afs/ee.cooper.edu/user/l/i/li14/AFSdrop/CATSnDOGS/';

switch whichPath
    case 'data'
        thePath = base;
    case 'imagenet'
        sub = 'external_data/imagenet/';
        thePath = fullfile(base,sub);
    case 'oxford'
        sub = 'external_data/oxford/';
        thePath = fullfile(base,sub);
end


end

