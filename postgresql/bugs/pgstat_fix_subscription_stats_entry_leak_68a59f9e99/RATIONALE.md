# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 68a59f9e99831cf05a746928a955781503232bbb ("pgstat: fix subscription stats entry leak."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/subscriptioncmds.c

Failing oracle cases:
- `src/test/subscription|t/026_stats.pl|Subscription stats for subscription 'test_tab2_sub' should be removed.`
