# Adapted injection for Default repr(C) enums to c_int size

Fix: https://github.com/rust-lang/rust/commit/2edf6c878449294efee45ca5b7f5a921658ff666

# Rationale
File: compiler/rustc_target/src/spec/mod.rs, `Target::parse_data_layout` (c_enum_min_size computation).
Change: `self.c_enum_min_bits.unwrap_or(self.c_int_width as _)` -> `.unwrap_or(32)`.
Re-expresses the fix hunk in spec/mod.rs that replaced `c_enum_min_bits: u64` (default `32`, "Defaults to 32")
with `Option<u64>` defaulting to c_int_width ("if None, matches c_int_width"). Pre-fix, repr(C) enums on
16-bit targets (AVR, MSP430) defaulted to 32 bits instead of c_int's 16.
