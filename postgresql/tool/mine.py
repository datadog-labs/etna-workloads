#!/usr/bin/env python3
"""List bug-fix candidates reachable from the release. Output: JSONL."""
import json, re, subprocess, sys, collections
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from pgpaths import is_impl, is_test, test_kind

REPO, REL = sys.argv[1], sys.argv[2]
FIX_SUBJ = re.compile(r'\b(fix(e[sd])?|repair|correct(ed|s)?|avoid|prevent|don\'?t|do not|bug|crash|wrong|incorrect|broken|oversight|mistake|failure|fail(s|ed)?|leak|race|assert(ion)?|regression|mishandl\w*|misbehav\w*|honor|properly|erroneous|bogus)\b', re.I)
BUGREF = re.compile(r'\b[Bb]ug #?\s?(\d{4,6})\b')
REPORTED = re.compile(r'^Reported[- ]by:', re.M | re.I)
BACKPATCH = re.compile(r'back-?(patch|port)', re.I)
DISC = re.compile(r'(https?://(postgr\.es/m|www\.postgresql\.org/message-id)/\S+)')
SEP = '\x1e'
out = subprocess.run(['git', '-C', REPO, 'log', '--no-merges', '--name-only', '--no-renames',
                      f'--format={SEP}%H%x00%aI%x00%an%x00%s%x00%b%x00', REL],
                     capture_output=True, text=True, errors='replace').stdout
cands, seen = [], collections.Counter()
for rec in out.split(SEP)[1:]:
    h, date, author, subj, body, files = rec.split('\x00', 5)
    files = [f for f in files.split('\n') if f.strip()]
    impl = [f for f in files if is_impl(f)]
    tests = [f for f in files if is_test(f)]
    if not impl or not tests:
        continue
    msg = subj + '\n' + body
    sig = []
    if FIX_SUBJ.search(subj): sig.append('fix-wording')
    bugs = sorted(set(BUGREF.findall(msg)))
    if bugs: sig.append('bug-ref')
    if REPORTED.search(body): sig.append('reported-by')
    if BACKPATCH.search(body): sig.append('backpatch')
    if re.search(r'^Security: CVE', body, re.M): sig.append('cve')
    if not sig:
        continue
    # require at least one "strong-ish" signal: fix wording in subject, bug ref, reporter or CVE
    if not ({'fix-wording', 'bug-ref', 'reported-by', 'cve'} & set(sig)):
        continue
    cands.append(dict(commit=h, date=date, author=author, subject=subj, signals=sig,
                      bug_refs=bugs, links=sorted(set(m[0] for m in DISC.findall(body)))[:5],
                      impl_files=impl, test_files=tests,
                      test_kinds=sorted(set(test_kind(t) for t in tests))))
    seen[(author, subj)] += 1
# backport duplicates: same author+subject reachable twice -> keep newest (first)
kept, dup = [], set()
for c in cands:
    k = (c['author'], c['subject'])
    if seen[k] > 1 and k in dup:
        continue
    dup.add(k); kept.append(c)
for c in kept:
    print(json.dumps(c))
print(f'candidates={len(kept)} dup_dropped={len(cands)-len(kept)}', file=sys.stderr)
