# Probe (step 1), 2026-11-08
Release v6.0.3 = 050880ce59 (2026-04-15). 36,748 commits reachable, 28,951 non-merge.
Candidates (tools/mine.py): 3,910 (834 with Fixes/Closes #N ref, 3,076 fix-wording only).
Backport picks dropped when the picked PR is itself reachable.
Reverse-apply of implementation diff on v6.0.3 (tools/probe.py):
clean 303, fuzzy (patch -F3) 147, conflict 3,460.
Pre-2023 commits almost never apply: Nov 2022 namespace->modules conversion and 2023 dprint reformat.
