#!/usr/bin/env python3
"""Export the dataset: one directory per gated bug + patches/ for Marauders.
usage: export.py OUTDIR"""
import json, os, sys, re, glob, shutil, subprocess, csv
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pgrun
W = pgrun.WORK
STRIP = re.compile(r'^(fix(es|ed)?|avoid|prevent|repair|correct|don\'?t|do not|ensure|make|handle|teach)\s+', re.I)

def slug(subject):
    s = STRIP.sub('', subject.strip())
    words = re.findall(r'[a-z0-9]+', s.lower())
    while words and words[0] in ('a', 'an', 'the', 'some', 'two', 'several', 'bug', 'bugs', 'in', 'of', 'with', 'for'):
        words = words[1:]
    out = ''
    for w in words:
        if len(out) + len(w) + 1 > 40: break
        out = f'{out}_{w}' if out else w
    return out or 'bug'

def locality(inj_files, fix_files):
    a, b = set(inj_files), set(fix_files)
    if a <= b: return 'same-files'
    if a & b: return 'overlap'
    return 'disjoint'

LOCAL = re.compile(r'/[^\s]*?/pg-etna-work/(agents|repro_agents|w|inst|anchor)/[^/\s]*')

def scrub(text):
    """Replace machine-local work paths in agent-written notes with placeholders."""
    return LOCAL.sub(lambda m: f'<{m.group(1)}-dir>', text)

def files_of(patch):
    return sorted(set(re.findall(r'^diff --git a/(\S+) b/', patch, re.M)))

def main(out):
    bugs = json.load(open(f'{W}/state/bugs.json'))
    cands = {json.loads(l)['commit']: json.loads(l) for l in open(f'{W}/candidates.jsonl')}
    os.makedirs(f'{out}/bugs', exist_ok=True); os.makedirs(f'{out}/patches', exist_ok=True)
    rows = []
    for b in bugs:
        c = cands[b['commit']]
        r = json.load(open(f'{W}/state/{b["tier"]}/{b["commit"]}.json'))
        name = f'{slug(b["subject"])}_{b["commit"][:10]}'
        d = f'{out}/bugs/{name}'
        shutil.rmtree(d, ignore_errors=True); os.makedirs(d)
        patch = r['stored']
        open(f'{d}/injection.patch', 'w').write(patch)
        open(f'{out}/patches/{name}.patch', 'w').write(patch)
        inj_files = files_of(patch)
        rp = f'{W}/state/repro/{b["commit"]}.json'
        rep = json.load(open(rp)) if os.path.exists(rp) else None
        repro_meta = None
        if rep and rep.get('status') == 'verified':
            fn = rep['repro_name']
            open(f'{d}/{fn}', 'w').write(rep['repro'])
            open(f'{d}/expected_clean.out', 'w').write(rep['expected_clean'])
            open(f'{d}/expected_injected.out', 'w').write(scrub(rep.get('expected_injected', '')))
            repro_meta = dict(file=fn, expected_clean='expected_clean.out', expected_injected='expected_injected.out',
                              clean_rc=rep['check']['clean_rc'], injected_rc=rep['check']['injected_rc'],
                              injected_stable=rep['check'].get('injected_stable'), model=rep.get('model'))
        if b['tier'] == 'adapted':
            rat = r.get('rationale') or '(agent wrote no RATIONALE.md)'
            if r.get('first_attempt'): rat += f"\n\n<!-- produced on retry with {r.get('model')} -->\n"
        else:
            rat = (f"# Verbatim injection\n\nThis injection is the reverse of the implementation hunks of upstream "
                   f"commit {b['commit']} (\"{b['subject']}\"), applied to REL_18_6 "
                   f"({'exactly' if r.get('apply') == 'exact' else 'with fuzz'}). It restores the code the fix replaced.\n\n"
                   f"Files: {', '.join(inj_files)}\n\nFailing oracle cases:\n" + ''.join(f'- `{x}`\n' for x in b['failing']))
        open(f'{d}/RATIONALE.md', 'w').write(scrub(rat))
        oracle = dict(cases=r['oracle'], failing=b['failing'], fix_added=b['fix_added'],
                      note='case id = <dir>|<tap file or empty>|<case>; pg_regress cases are whole test files, '
                           'TAP cases are subtest names (normalised). Oracle = cases passing in two base runs.')
        json.dump(oracle, open(f'{d}/oracle.json', 'w'), indent=1)
        worst = 0.0
        for run in r.get('runs', []):
            m = re.search(r'# (\d+) of (\d+) tests failed', run.get('tail', ''))
            if m: worst = max(worst, int(m.group(1)) / int(m.group(2)))
            elif run.get('ncases') == 0: worst = 1.0
        ap = f'{W}/state/anchor/{b["commit"]}.json'
        anc = json.load(open(ap)) if os.path.exists(ap) else {}
        notes = []
        if b['commit'].startswith('c3c35a733c'):
            notes.append('host-sensitive: the injected build allocates memory without bound in spgist tests '
                         '(observed 45 GB RSS); run under a memory limit')
        if meta_locality := locality(inj_files, c['impl_files']):
            if meta_locality == 'disjoint':
                notes.append('injection touches none of the files the fix touched (often code moved since); review')
        meta = dict(name=name, fix_commit=b['commit'], fix_date=c['date'], fix_subject=b['subject'],
                    fix_url=f'https://github.com/postgres/postgres/commit/{b["commit"]}',
                    report_links=c['links'], bug_refs=[f'BUG #{n}' for n in c['bug_refs']],
                    signals=c['signals'], release='REL_18_6', release_commit='724edf9bde9d356724ad384a2e196edc3c9f80f7',
                    tier=b['tier'], apply=r.get('apply'), strict=b['strict'], not_strict_reasons=b['not_strict_reasons'],
                    labels=dict(label=b['label'], symptom=b['symptom'], subsystem=b['subsystem'],
                                confidence=b['confidence'], model='haiku'),
                    injection_files=inj_files, fix_impl_files=c['impl_files'],
                    locality=locality(inj_files, c['impl_files']),
                    fix_added_rule=sorted(set(b['fix_added'].values())),
                    anchor=b.get('anchor'), anchor_common=b.get('anchor_common'),
                    anchor_build=anc.get('build'), anchor_compat_edits=anc.get('compat_edits'),
                    regated_after_shm_incident=bool(r.get('regated')),
                    collateral_fail_fraction=round(worst, 2), notes=notes,
                    agent_model=r.get('model') if b['tier'] == 'adapted' else None,
                    reproducer=repro_meta)
        json.dump(meta, open(f'{d}/meta.json', 'w'), indent=1)
        rows.append(dict(name=name, commit=b['commit'][:12], date=c['date'][:10], tier=b['tier'], strict=b['strict'],
                         symptom=b['symptom'], subsystem=b['subsystem'], locality=meta['locality'],
                         reproducer=bool(repro_meta), n_failing=len(b['failing'])))
    with open(f'{out}/bugs.csv', 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0])); w.writeheader(); w.writerows(rows)
    print(len(rows), 'bugs exported;', sum(r['strict'] for r in rows), 'strict;', sum(r['reproducer'] for r in rows), 'with reproducer')

if __name__ == '__main__':
    main(sys.argv[1])
