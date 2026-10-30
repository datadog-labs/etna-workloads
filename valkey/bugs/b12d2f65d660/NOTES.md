Adds a stream entry with the maximum ID, then runs XADD with *. The clean build returns an exhausted-ID error and XLEN stays 1. The buggy build wraps around, returns 0-0 and XLEN is 2.
