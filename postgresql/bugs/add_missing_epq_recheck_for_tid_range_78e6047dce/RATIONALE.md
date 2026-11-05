# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 78e6047dcea588ec127f6a71c7cebd5c0f41d795 ("Add missing EPQ recheck for TID Range Scan"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeTidrangescan.c

Failing oracle cases:
- `src/test/isolation||eval-plan-qual`
