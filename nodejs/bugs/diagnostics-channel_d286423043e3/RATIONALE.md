# diagnostics_channel: validate before channel activation

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit d286423043e3b1a926e713cbb0a1c5e6bab049ac applied to v26.13.0 (clean).

Upstream commit message:

```
diagnostics_channel: validate before channel activation

Validate the first subscription before calling markActive().
This prevents invalid callbacks from leaving channels active and
notifying native consumers without an installed subscriber.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: codex:gpt-5.6-sol
PR-URL: https://github.com/nodejs/node/pull/65313
Fixes: https://github.com/nodejs/node/issues/65312
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Gerhard Stöbich <deb2001-github@yahoo.de>
```
