function Y = decimate_array(A, D)
% Y = DECIMATE_ARRAY(A, decimation_factor)
%
%   This returns a lazily decimated array (smoothed and sampled). If X has
%   more than 3 dimensions (YXZT, YXZCT), the decimation is only applied to
%   the first two dimensions.
%
% Author: Vivek Venkatachalam (vivekv2@gmail.com)

h = fspecial('gaussian', D*3, D);
smth = @(x) imfilter(x, h);

if ndims(A) == 5
    shrink = @(x) x(1:D:end, 1:D:end, :, :);
elseif ndims(A) == 4
    shrink = @(x) x(1:D:end, 1:D:end, :);
elseif ndims(A) == 3
    shrink = @(x) x(1:D:end, 1:D:end);
end


Y = LazyArray(A, @(x) shrink(smth(x)));