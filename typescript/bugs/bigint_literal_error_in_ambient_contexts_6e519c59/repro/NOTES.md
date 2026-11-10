Input declares an ambient const with a BigInt literal initializer (`declare const n = 123n;`) and is compiled with --target es2015.
Clean: no diagnostics, exit 0. Injected: reports error TS2737 "BigInt literals are not available when targeting lower than ES2020", exit 2.
