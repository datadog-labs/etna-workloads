# src: fix crash when writing odd-length hex string via Writev

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 8725e569286a3be473ebdaafaa0e5670737614b9 applied to v26.13.0 (clean).

Upstream commit message:

```
src: fix crash when writing odd-length hex string via Writev

StringBytes::StorageSize had a CHECK that fatal-asserted when a
hex-encoded string with an odd number of characters was written
through Writev (e.g. via HTTP requests which are automatically
corked). Writing the same string via a single Write did not crash
because StringBytes::Write delegates to HexDecode, which silently
drops the trailing incomplete nibble.

Remove the CHECK and let integer division handle odd lengths, which
is consistent with StringBytes::Size and HexDecode.

Fixes: https://github.com/nodejs/node/issues/45150
Signed-off-by: RajeshKumar11 <kakumanurajeshkumar@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/63658
Reviewed-By: Edy Silva <edigleyssonsilva@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Gürgün Dayıoğlu <hey@gurgun.day>
```
