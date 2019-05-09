# lazy-matlab-arrays
Lazy loading, lazy transformations, and memory-caching for MATLAB.

These are useful if:

1. You are spending a lot of time waiting on data to load or arrays to be transformed in a slice-by-slice manner.
2. You don't always need every slice loaded and transformed.
3. The largest dimension of your array is the last one (e.g. a timeseries of images).
4. You don't need to mutate arrays.


To load data from disk, use one of the disk loaders.

    > A = MatfileArray("data.mat", "myfield")
    > A = HDF5Array("data.h5", "myfield")
    > A = BioFormatsArray("proprietary_file.nd2") % Uses bfmatlab (included)

To transform data, specify a function to operate on the first `N-1` dimensions of the array (a slice).

    > B = LazyArray(A, @my_slice_function, {arg2, arg3}) % calls my_slice_function(A_slice, arg2, arg3)

You can also subclass `LazyArray`. Some examples are provided [here](arrays/transformations).

    > B = CroppedArray(A, crop_size, centers) % Take a moving crop from A.

If your transformations take some time, and you make repeated requests from the same slice of a transformed array, you may want to cache results.

    > B = LazyArray(A, @super_slow_function)
    > C = CachedArray(B)
    > get_slice(C, 30); % super slow
    > get_slice(C, 30); % super fast

While these arrays can often be handled by built-in functions, they don't support the full functionality of built-in arrays. Most notably, they cannot be written to (immutable by design). If you ever need to convert them to a standard in-memory array, use `get_array_data`:

    > D = get_array_data(B); % This will take a long time and a lot of memory.
    > D = get_array_data(CachedArray(B)); % This takes twice as much memory. Don't do it.