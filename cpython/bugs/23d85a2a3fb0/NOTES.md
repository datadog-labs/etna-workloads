Packs a double sNaN whose payload is entirely truncated (0x80001) into float32 and
float16 via struct. Clean gives a qNaN (`0000c07f`, `007e`); buggy gives
`0000807f` / `007c`, which is infinity, not NaN. The second case (payload preserved)
is identical in both.
