# Verbatim injection for c-variadic: fix i128 argument being misread on aarch64 msvc

Fix: https://github.com/rust-lang/rust/commit/acccc68b623325aaf1117a3696fe063b2b16b37c

The injection is the reverse of the fix's implementation hunks, applied to 1.99.1 (clean).
