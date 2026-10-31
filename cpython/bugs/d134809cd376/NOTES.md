Reproducer: NFC-normalizes three Hangul sequences (U+1176 vowel, U+11A7 and U+11C3 trailing consonants), which are outside the modern jamo ranges and must not compose.
Clean leaves them unchanged; the buggy build wrongly composes them into precomposed syllables (off-by-one range bounds in nfc_nfkc).
