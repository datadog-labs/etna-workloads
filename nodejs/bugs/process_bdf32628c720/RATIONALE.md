# process: fix finalization cleanup ref tracking

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit bdf32628c720fd3a1a07e12e983eaf06bbf8ba76 applied to v26.13.0 (clean).

Upstream commit message:

```
process: fix finalization cleanup ref tracking

Use SafeSet collections for finalization refs so insertion, removal,
and emptiness checks match the identity-based tracking model.

This also fixes cleanup removal for collected refs. Previously cleanup
used the ref index as the splice delete count, which could remove later
live refs when the collected ref was not first.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: openai:gpt-5.5
PR-URL: https://github.com/nodejs/node/pull/64087
Fixes: https://github.com/nodejs/node/issues/64086
Reviewed-By: René <contact.9a5d6388@renegade334.me.uk>
```
