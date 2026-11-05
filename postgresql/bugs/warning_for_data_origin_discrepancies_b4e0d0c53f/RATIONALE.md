# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b4e0d0c53fabe7d19b6a081d6c2b98aa4df55295 ("Fix a WARNING for data origin discrepancies."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/subscriptioncmds.c

Failing oracle cases:
- `src/test/subscription|t/030_origin.pl|Create subscription with origin = none and copy_data when the publisher's ancestor is subscribing from different origin`
- `src/test/subscription|t/030_origin.pl|Create subscription with origin = none and copy_data when the publisher's partition is subscribing from different origin`
