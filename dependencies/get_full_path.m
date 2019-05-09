function y = get_full_path(x)
% y = GET_FULL_PATH(x)
%
%   Returns the full path of a (possibly relative) path x.
%
% Author: Vivek Venkatachalam (vivekv2@gmail.com)



if x(2) == ':' || x(1) == '/' % x is an absolute path
    
    y = x;
    
else % x is a relative path
    
    current_directory = pwd;
    
    y = fullfile(current_directory, x);
    
end