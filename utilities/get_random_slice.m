function y = get_random_slice(x)
% y = GET_RANDOM_SLICE(x)
%
%  Return a random slice from the last dimension of x.
%
% Author: Vivek Venkatachalam (vivekv2@gmail.com)

s = size(x);
n_slices = s(end);

idx = randi(n_slices);

y = get_slice(x, idx);