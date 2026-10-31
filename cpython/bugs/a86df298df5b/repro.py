import os, shutil

os.mkdir('d')
open('d/f', 'w').close()
for target in ('d/nonexisting', 'd/f'):
    for dry_run in (False, True):
        try:
            shutil.make_archive('out', 'tar', target, dry_run=dry_run)
            print(target, dry_run, 'no error')
        except OSError as e:
            print(target, dry_run, type(e).__name__, e.errno, e.filename)
        print(os.path.exists('out.tar'))
        if os.path.exists('out.tar'):
            os.unlink('out.tar')
