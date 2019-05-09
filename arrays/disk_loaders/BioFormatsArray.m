classdef BioFormatsArray < ArrayBase
    % BIOFORMATSARRAY Immutable array interface to arrays loaded using
    %  'bfopen'. Currently, this only works for 5D arrays.
    %
    % Author: Vivek Venkatachalam (vivekv2@gmail.com)

    properties (SetAccess = immutable)

        % File to read
        Filename

        % Loaded data from 'bfopen' (external library)
        BioformatsData

    end

    methods

        function obj = BioFormatsArray(filename)

            obj.Filename = filename;

            obj.BioformatsData = bfopen(filename);
            metadata = obj.BioformatsData{2};
            omeMeta = obj.BioformatsData{4};

            size_X = omeMeta.getPixelsSizeX(0).getValue; % 512
            size_Y = omeMeta.getPixelsSizeY(0).getValue; % 512
            size_Z = omeMeta.getPixelsSizeZ(0).getValue; % 31
            size_T = omeMeta.getPixelsSizeT(0).getValue; % 615
            size_C = omeMeta.getPixelsSizeC(0).getValue; % 2

            obj.Size = [size_Y, size_X, size_Z, size_C, size_T];

            obj.ElementClass = class(obj.BioformatsData{1}{1});

        end

        function [varargout] = subsref(this, S)

            % Determine which slices we will need to transform
            requested = S.subs{ndims(this)};

            % Expand ':' for sliced dimension.
            if ischar(requested) && requested == ':'
                requested = 1:this.Size(end);
            end

            data = zeros([this.Size(1:end-1) length(requested)], ...
                this.ElementClass);

            idx = num2cell(repmat(':', 1, length(this.Size)));
            for i = 1:length(requested)

                idx{end} = i;
                data(idx{:}) = this.get_slice(requested(i));

            end

            new_S = S;
            new_S.subs{ndims(this)} = ':';
            varargout{1} = subsref(data, new_S);

        end

        function data = get_slice(this, t)

            assert(numel(t)==1, ...
                'get_slice can only be called on single slices');

            size_Y = this.Size(1);
            size_X = this.Size(2);
            size_Z = this.Size(3);
            size_C = this.Size(4);

            data = zeros(size_Y, size_X, size_Z, size_C, 'uint16');

            for z = 1:size_Z
                for c = 1:size_C
                    idx = (t-1)*size_Z*size_C + (z-1)*size_C + c;
                    data(:,:,z,c) = this.BioformatsData{1}{idx,1};
                end
            end

        end
    end

end

