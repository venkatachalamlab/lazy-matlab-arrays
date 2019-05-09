function y = uint8_from_frame(frame, params)
% y = UINT8_FROM_FRAME(frame, params)
%
%  Convert to 8-bit using specificed downsampling parameters.
%
% Author: Vivek Venkatachalam (vivekv2@gmail.com)

if nargin < 2
    params = get_downsampling_parameters(frame, 0.95);
end

y = zeros(size(frame), 'uint8');

for i = 1:size(frame,3)
    
    cutoff = params{i}.cutoff;
    bit_offset = params{i}.bit_offset;
    
    y(:,:,i) = get_byte(frame(:,:,i), cutoff, bit_offset);
    
end