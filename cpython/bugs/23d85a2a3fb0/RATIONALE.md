# gh-141042 sNaN packing

Changes, all in `Objects/floatobject.c`:

1. `PyFloat_Pack2`: removed the `if (!bits) bits |= (1<<9);` block (reverses the
   fix hunk that added "set qNaN if no payload"). An sNaN whose payload is
   truncated away now packs as Infinity (0x7c00) instead of a qNaN.
2. `PyFloat_Pack4`, non-RISC-V branch: restored the unconditional
   `u32 &= ~(1 << 22); /* make sNaN */` in place of the fix's
   `if (u32 & 0x3fffff)` guard. A truncated-payload sNaN now packs as Infinity.
   (The RISC-V branch was left alone; it is not built here.)

Oracle failures: `test_pack_unpack_nans_for_different_formats` fails (both
endians): `pack(4, snan_low)` gives `7f800000` instead of `7fc00000`.
