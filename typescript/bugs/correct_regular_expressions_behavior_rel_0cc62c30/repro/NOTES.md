input.ts has regex literals with backreferences to nonexistent groups (`/\1/`, `/(a)\2/`) in non-unicode (Annex B) mode.
Clean tsc reports the "backreference refers to a group that does not exist" errors.
Injected tsc only reports them in unicode/non-Annex-B mode, so it prints no diagnostics.
