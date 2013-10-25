function [ thePath ] = getPath( whichPath )
%GETPATH Returns certain hardcoded paths
%   'data' : the base data directory
%   'imagenet' : the imagenet external database

if nargin<1; whichPath = 'data'; end;

switch whichPath
    case 'data'
        thePath = '/afs/ee.cooper.edu/user/l/i/li14/AFSdrop/CATSnDOGS/';
    case 'imagenet'
        thePath = '/afs/ee.cooper.edu/user/l/i/li14/AFSdrop/CATSnDOGS/external_data/imagenet/';
end



end

