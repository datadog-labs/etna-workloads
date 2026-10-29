Runs the window6-10.0 query: `count() FILTER (...) OVER w` (zero-arg aggregate with FILTER and a window frame).
Expected output `1`. The buggy shell fails (assertion in window.c windowAggStep) instead of printing it.
