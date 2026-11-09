Input: a function with a switch over `-1 | 0 | 1`; the script asks the language service for completions inside the empty switch body.
The "case ...: ..." snippet completion should insert `case -1:\ncase 0:\ncase 1:` (clean).
The injected build emits the negative literal incorrectly (no prefix minus), so the insertText differs or the call fails.
