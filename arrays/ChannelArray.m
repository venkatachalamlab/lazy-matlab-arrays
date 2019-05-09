classdef ChannelArray < handle & ArrayBase
    % CHANNELARRAY Allows mixed numeric and categorical indexing into
    % multichannel arrays.
    %
    % Author: Vivek Venkatachalam (vivekv2@gmail.com)

    properties (SetAccess = immutable)

        % Base array.
        Array

        % Map of dimension to map: dimension -> (category -> index)
        Categories

    end

    methods

        function obj = ChannelArray(x, channel_map)
            % y = CHANNELARRAY(x, channel_map)
            %
            %   Creates a read-only array that allows mixed numeric and
            %   categorical indexing into multichannel arrays. channel_map
            %   should be a containers.Map object mapping dimension to a
            %   map from categories to index.
            %
            %   For an RGB image, a typical channel_map would be:
            %     RGB_map = containers.Map({'r', 'g', 'b'}, [1, 2, 3]);
            %     channel_map = containers.Map(3, RGB_map);
            %
            %   Using this, we would have:
            %
            %       y = CHANNELARRAY(x, channel_map);
            %       y(342, 23, 2) == y(342, 23, 'g');
            %       y(342, 23, 1:2) == y(342, 23, {'r', 'g'});
            %
            %   A more versetile RGB map may be
            %
            %     RGB_map = containers.Map(...
            %       {'r', 'R', 'red', 'Red', ...
            %        'g', 'G', 'green', 'Green', ...
            %        'b', 'B', 'blue', 'Blue'}, ...
            %       [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3]);
            %
            %   This would allow indexing with either y(3,4,'r') or
            %   y(3,4,'Green').

            obj.Array = x;
            obj.Size = size(x);
            obj.Categories = channel_map;
            obj.ElementClass = element_class(x);

        end

        function [varargout] = subsref(this, S)

            if strcmp(S.type, '()')

                for i = 1:length(S.subs)

                    idx = S.subs{i};

                    if ischar(idx) && ~strcmp(idx, ':')

                        channel_map = this.Categories(i);
                        S.subs{i} = channel_map(idx);

                    elseif iscell(idx)

                        channel_map = this.Categories(i);
                        S.subs{i} = cellfun(@(x) channel_map(x), idx);

                    end

                end

                varargout{1} = subsref(this.Array, S);

            end

        end

        function A = array(this)
            A = this.Array;
        end

        function C = channels(this)
            C = this.Categories;
        end

        function A = reshape(this, varargin)
            A = reshape(array(this), varargin{:});
        end

        function A = double(this)
            A = double(array(this));
        end

    end

    methods (Static)

        function obj = from_channels(chans, names, stitch_dimension)
            % obj = ChannelArray.from_channels(chans, names, dimension)
            %
            %   This creates a ChannelArray object from a cell array of
            %   arrays (chans). names should specify a cell array of
            %   channel names, and dimension should specify the dimension
            %   to stitch along (default is the last dimension).
            %
            %   obj will have one more dimension than the arrays in chans.
            %
            %   If you have more than one categorically indexed channel you
            %   must use the full constructor.

            N = ndims(chans{1}) + 1;
            cls = element_class(chans{1});

            chan_size = size(chans{1});
            if nargin < 3
                stitch_dimension = N;
            end
            siz = [chan_size(1:stitch_dimension-1) length(chans) ...
                chan_size(stitch_dimension:end)];

            idx = cell(1,N);
            [idx{:}] = deal(':');

            array = zeros(siz, cls);
            cat_map = containers.Map('KeyType', 'char', ...
                'ValueType', 'double');

            for i = 1:length(chans)

                idx{stitch_dimension} = i;
                array(idx{:}) = chans{i};

                cat_map(names{i}) = i;

            end

            obj = ChannelArray(array, containers.Map(stitch_dimension, ...
                cat_map));

        end

    end

end
