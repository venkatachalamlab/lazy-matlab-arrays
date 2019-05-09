function y = get_byte(x, val_offset, byte_offset)

y = uint8(bitshift(x-val_offset,-byte_offset));