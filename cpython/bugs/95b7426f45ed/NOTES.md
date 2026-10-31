repro.py defines a plain `Flag` with A=1, B=2 and an alias MASK=255, then prints `~OpenAB.MASK`.

- Clean: `<OpenAB: 0>`. Inversion uses `_singles_mask_ & ~value`, so only the defined single bits are kept.
- Buggy: `<OpenAB: 252>`. The injected code uses `_singles_mask_ ^ value`, which leaves bits outside the members set.
