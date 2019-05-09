classdef AnnotatedArray < ArrayBase
    % ANNOTATEDARRAY Annotates frames in an array in a lazy way.
    %
    % Author: Vivek Venkatachalam (vivekv2@gmail.com)

    properties (SetAccess = immutable)

        Preimage
        
        SlicedDimension
        
        NSlices

    end
    
    properties
    
        Functions
        
        FunctionArgs
        
    end

    methods

        function obj = AnnotatedArray(array, varargin)
            
            default_options = struct(...
                'Functions', {{}}, ...
                'FunctionArgs', {{}} ...
            );
            input_options = varargin2struct(varargin{:}); 
            options = merge_struct(default_options, input_options);

            obj.Preimage = array;
            
            obj.Size = size(array);
            
            obj.ElementClass = element_class(array);
            
            obj.SlicedDimension = numel(obj.Size);
            
            obj.NSlices = obj.Size(end);
            
            obj.Functions = options.Functions;
            obj.FunctionArgs = options.FunctionArgs;

        end
        
        function [varargout] = subsref(this, S)

            % Determine which slices we will need to transform
            requested = S.subs{this.SlicedDimension};

            data = zeros([this.Size(1:end-1) length(requested)], ...
                this.ElementClass);

            idx = num2cell(repmat(':', 1, length(this.Size)));
            for i = 1:length(requested)

                idx{end} = i;
                data(idx{:}) = this.get_slice(requested(i));

            end

            new_S = S;
            new_S.subs{this.SlicedDimension} = ':';
            varargout{1} = subsref(data, new_S);

        end
        
        function data = get_slice(this, t)
            
            assert(numel(t)==1, ...
                'get_slice can only be called on single slices');

            idx = num2cell(repmat(':', 1, length(this.Size)));
            idx{end} = t;

            data = subsref(this.Preimage, ...
                struct('type', '()', 'subs', {idx}));

            for i = 1:length(this.Functions)
                
                f = this.Functions{i};
                x = this.FunctionArgs{i};
                
                data = f(data, x{:}, this, t);
                
            end
            
        end

    end

    methods (Static)

        function data = timestamp(data, position, array_obj, idx)

            s = size(array_obj);
            text = sprintf('%d / %d', idx, s(end));
            data = insertText(data, position, text);

        end

    end


end

