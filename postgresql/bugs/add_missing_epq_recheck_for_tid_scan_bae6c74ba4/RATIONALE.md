# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit bae6c74ba4e4e4fdbb45e45569a5b53f27590b1c ("Add missing EPQ recheck for TID Scan"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeTidscan.c

Failing oracle cases:
- `src/test/isolation||eval-plan-qual`
