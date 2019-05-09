function video_from_array(array, filename, varargin)
% VIDEO_FROM_ARRAY(array, filename)
%
%   This will take an array and write it out to a video.
%
%  VIDEO_FROM_ARRAY(array, filename, frames)
%
%   This will take an array and write the specified frames to a video.
%
% Author: Vivek Venkatachalam (vivekv2@gmail.com)

S = size(array);

size_T = S(end);

default_options = struct(...
    'frames', 1:size_T, ...
    'framerate', 30, ...
    'extra_scale', 1 ...
);

input_options = varargin2struct(varargin{:}); 
options = merge_struct(default_options, input_options);


writer = VideoWriter(filename, 'MPEG-4');
writer.FrameRate = options.framerate;

open(writer);
for t = options.frames
    
    frame = get_slice(array, t) * options.extra_scale;
    writeVideo(writer, frame);
    
end
close(writer);