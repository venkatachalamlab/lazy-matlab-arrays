function params = get_downsampling_parameters(frame, threshold)
% params = GET_DOWNSAMPLING_PARAMETERS(frame, threshold)
%
%   
%
% Author: Vivek Venkatachalam (vivekv2@gmail.com)

for i = 1:size(frame, 3)

    x = frame(:,:,i);

    params{i}.cutoff = min(quantile(row(x),threshold), max_all(x)*0.75);

    range = double(max_all(x)-params{i}.cutoff);
    bitrange = floor(log2(range));
    params{i}.bit_offset = bitrange - 8;

end