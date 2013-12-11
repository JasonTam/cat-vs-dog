function [ wdFeatures ] = getWav( I, levels )
%GETWAV Summary of this function goes here
%   Detailed explanation goes here

if nargin<2 
    levels = 6;
end

[c,s] = wavedec2(I,levels,'db4');
ps = prod(s,2);
ps(2:end) = ps(2:end)*3;

cuml = [0;cumsum(ps)];

% dec_mean = zeros(1,levels+1);
dec_absmean = zeros(1,levels+1);
dec_std = zeros(1,levels+1);
dec_rat = zeros(1,levels);
%%

% Get Detail Coeffs
for ii = 1:levels+1
   c_dec{ii} = c(cuml(ii)+1:cuml(ii+1));
   
%    dec_mean(i) = mean(c_dec{i});
   dec_absmean(ii) = mean(abs(c_dec{ii}));
   dec_std(ii) = std(c_dec{ii});
end
dec_rat = dec_absmean(2:end)./dec_absmean(1:end-1);

% get rid of the first one since it's approx coeff
wdFeatures = [dec_absmean(2:end) dec_std(2:end) dec_rat(2:end)];

end

% Matrix S is such that
% 
% S(1,:) = size of approximation coefficients(N).


% We just want the detail coeffs
% S(i,:) = size of detail coefficients(N-i+2) for i = 2, ...N+1 and S(N+2,:) = size(X).