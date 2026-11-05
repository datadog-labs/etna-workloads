# Probe (step 1) — PostgreSQL @ REL_18_6 (724edf9bde9d)

Mining: non-merge commits reachable from REL_18_6 (62,601; PostgreSQL has no merges) that touch
implementation files in src/ (excl. src/test/, TAP t/ dirs, pl/ecpg test dirs, build files, .po,
README, tz data) AND src/ test files, AND carry a fix signal: fix wording in subject, "Bug #N",
Reported-by:, or Security: CVE (back-patch notes recorded but not sufficient alone).
Backport duplicates (same author+subject reachable twice): 21 dropped.

Candidates: 2687.  Reverse-apply of implementation hunks on REL_18_6:
  clean (git apply -R --check) 517 | fuzzy (patch -R -F3) 181 | conflict 1989

By year (clean/fuzzy/conflict): 2026 94/1/12, 2025 107/17/51, 2024 92/26/134, 2023 64/23/104,
2022 40/11/94, 2021 33/19/126, 2020 20/22/97, 2019 24/17/152, 2018 17/17/128, 2017 6/7/140,
2016 8/10/89, 2015 2/5/92, 2011-2014 7/6/203, <=2010 3/0/807 (no clean/fuzzy before 2005).

By test kind (a commit can count in several): regress 2058 (373/139/1546), tap 340 (87/24/229),
ecpg 114, module 100, isolation 96, pl 88, other 50.

Timings on this host (16 cores): full cassert build 62 s, `make check` (231 regress tests) 21 s.
