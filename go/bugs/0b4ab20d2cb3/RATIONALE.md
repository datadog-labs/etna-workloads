# Rationale

Fix (#68658): honor //go:build downgrades only when the file version is >= go1.21.
In go1.27.3 the pre-fix `cmp > 0 || cmp < 0 && downgradeOk` logic was replaced by
`v = max(fileVersion, go1_21)` in `types2/check.go` initFiles. That `versionMax(..., go1_21)`
is the modern form of the fix's `fileVersion.cmp(go1_21) >= 0` clamp.

Change: `v = string(versionMax(fileVersion, go1_21))` -> `v = string(fileVersion)`
(src/cmd/compile/internal/types2/check.go). The file's //go:build version is used as-is,
so a downgrade to a pre-1.21 version (e.g. `//go:build go1.19`) is honored again,
which is the bug the fix removed.

Failing oracle cases: TestCheck/go1_20_19.go, TestCheck/go1_21_19.go, TestCheck/go1_xx_19.go
(and TestCheck), TestFileVersions. A file with //go:build go1.19 and -lang=go1.20/1.21 now
errors on 1.20-era features ("requires go1.20 or later") instead of compiling.
