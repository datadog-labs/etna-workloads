import json,os,subprocess,sys
W=os.path.expanduser("~/ts-etna-work")
cs={c['sha'][:12]:c for c in map(json.loads,open(W+'/candidates.jsonl'))}
def ch(b,n):
    out=[l for l in b.replace('\r','').split('\n') if (l[:1] in '+-') and not l.startswith(('+++','---')) and l[1:].strip()]
    return '\n'.join(x[:150] for x in out[:n])
for d in sys.argv[1:]:
    s=d.split('/')[-1]; c=cs[s]; r=json.load(open(f'{W}/{d}/result.json'))
    fix=subprocess.run(['git','-C',W+'/ts','diff',c['sha']+'^',c['sha'],'--',*c['impl_files']],capture_output=True,text=True,errors='replace').stdout
    inj=open(f'{W}/{d}/injection.patch',errors='replace').read()
    print(f"################ {d}  {c['subject'][:90]}\nfix files {c['impl_files']} inj files {r['files']}")
    print('--- FIX:\n'+ch(fix,16)); print('--- INJ:\n'+ch(inj,16))
    print('--- failing_added:',[t[-90:] for t in r['failing_added'][:2]], len(r['failing']))
