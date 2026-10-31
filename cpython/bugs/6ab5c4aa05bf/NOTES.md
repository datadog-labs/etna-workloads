Reproducer drives a pyrepl Reader (mock console) with the text "# non ‌ printing character"
(contains a zero-width non-joiner, a non-printing char shown as `‌`), then calls
`reader.setpos_from_xy(8, 0)` and prints `reader.pos`.
Clean prints 7; buggy prints 9 (the non-printing char's display width is computed as 0 instead of 6).
