Reproducer: EVAL hincrby with a Lua number arg 200000000. Clean converts it to integer string and returns {number,200000000}; buggy passes 2e+08 via fpconv_dtoa so hincrby errors (not an integer).
