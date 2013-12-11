function [ fileList ] = pruneTypes( fileList, fType )
%PRUNETYPES Summary of this function goes here
%   Detailed explanation goes here

typeInds = cellfun(@(x) strcmp(x(end-numel(fType)+1:end),...
  fType),fileList);

fileList = fileList(typeInds);



end

