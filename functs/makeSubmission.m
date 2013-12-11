function [ output_args ] = makeSubmission( fPath, guess )
%MAKESUBMISSION Summary of this function goes here
%   Detailed explanation goes here

head = {'id', 'label'};

fid = fopen(fPath, 'w');
    fprintf(fid, '%s,%s\n', head{:});
fclose(fid);

dlmwrite(fPath,guess,'-append');




end

