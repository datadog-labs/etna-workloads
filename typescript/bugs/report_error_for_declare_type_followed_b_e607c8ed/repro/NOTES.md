Input is `declare type` followed by a newline and then `T = string;`.
Clean: reports error TS1142 "Line break not permitted here" and exits non-zero.
Injected: parses `declare` as an identifier expression statement and reports different errors (no TS1142).
