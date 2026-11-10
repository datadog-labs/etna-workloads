Language-service script: 250 modules export `aa_N__0`; with `allowIncompleteCompletions` the user types `a` (incomplete auto-import response, cached), then `aa` (TriggerForIncompleteCompletions continuation).
The continuation response should update `optionalReplacementSpan` to cover the newly typed text: clean gives `{start:0,length:2}`.
Injected build keeps the stale span from the first response (`length:1`).
