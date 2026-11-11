# Adapted injection for Open the FileEncoder file for reading and writing

Fix: https://github.com/rust-lang/rust/commit/09960e03194626738b3533b6c2d06a0c505117d3

# Rationale
compiler/rustc_serialize/src/opaque.rs, `FileEncoder::new`: removed the `File::options().read(true).write(true).create(true).truncate(true).open(&path)?` (and its comment) and restored `file: File::create(path)?`. Re-expresses the fix hunk `@@ -38,11 +38,16 @@ pub struct FileEncoder` (which added that options line and replaced `file: File::create(path)?` with `file`). File is write-only again, so -Zmeta-stats rewinding/reading fails.
