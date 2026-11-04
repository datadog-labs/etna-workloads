repro.sql computes the median (percentile_cont(0.5)) of the Float16 values 0 and 65504 (max finite f16).
Clean build returns 32752; the buggy build interpolates in f16, which overflows, and returns NaN.
