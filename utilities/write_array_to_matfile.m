function write_array_to_matfile(A, filename, field)
% WRITE_ARRAY_TO_MATFILE(A, filename, field)
%
%   Writes the given array to the given filename and field (default
%   'data'). This will write out slice by slice.
%
% Author: Vivek Venkatachalam (vivekv2@gmail.com)

if nargin < 3
    field = 'data';
end

clk = tic();

mfile = matfile(filename, 'Writable', true);

S = size(A);
size_T = S(end);

idx = {};
for i = 1:length(S)
    idx{i} = 1:S(i);
end
idx{end} = 1:2;

clear temp;
temp(idx{:}) = 0;
mfile.(field) = uint8(temp);

disp(['Beginning to merge slices. Time elapsed: ' num2str(toc(clk))]);

for t = 1:size_T
    idx{end} = t;
    disp(['Time ' num2str(t) ' out of ' num2str(size_T) '. Elapsed time: ' ...
        num2str(toc(clk))]);
    mfile.data(idx{:}) = get_slice(A, t);
end