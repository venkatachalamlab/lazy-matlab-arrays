function y = get_sample_slices(x, count)
% y = GET_SAMPLE_SLICES(x, count)
%
%   This returns a list of values obtained by uniformly extracting slices
%   of the array x along the last dimension
%
% Author: Vivek Venkatachalam (vivekv2@gmail.com)

s = size(x);

if nargin < 2
    count = 100;
end

if s(end) <= count
    
    y = x(:);
    
else
    
    step = floor(s(end)/count);
    idx = 1:step:s(end);
    
    y = [];
    
    for i = idx
        
        new_vals = get_slice(x, i);
        y = [y; new_vals(:)];
        
    end
    
end