#!/usr/bin/env python3
"""Kill any process whose executable lives under ~/pg-etna-work and whose RSS exceeds the limit."""
import os, time, signal, sys
ROOT = os.environ.get('ETNA_WORK', os.path.expanduser('~/pg-etna-work')).rstrip('/') + '/'
LIMIT_KB = int(sys.argv[1]) if len(sys.argv) > 1 else 6 * 1024 * 1024
LOG = ROOT + 'logs/memwatch.log'
while True:
    for pid in os.listdir('/proc'):
        if not pid.isdigit(): continue
        try:
            exe = os.readlink(f'/proc/{pid}/exe')
            if not exe.startswith(ROOT): continue
            rss = next(int(l.split()[1]) for l in open(f'/proc/{pid}/status') if l.startswith('VmRSS:'))
            if rss > LIMIT_KB:
                cwd = os.readlink(f'/proc/{pid}/cwd')
                os.kill(int(pid), signal.SIGKILL)
                with open(LOG, 'a') as f:
                    f.write(f'{time.ctime()} killed {pid} rss={rss//1024}MB exe={exe} cwd={cwd}\n')
        except (OSError, StopIteration):
            pass
    # orphaned POSIX shm segments (left by SIGKILLed postmasters) fill the 64 MB /dev/shm and break
    # every later initdb/parallel query; remove ours that no process maps and that are >5 min old
    try:
        inuse = set()
        for pid in os.listdir('/proc'):
            if pid.isdigit():
                try:
                    for l in open(f'/proc/{pid}/maps'):
                        if '/dev/shm/' in l: inuse.add(l.split('/dev/shm/')[1].split()[0])
                except OSError: pass
        for f in os.listdir('/dev/shm'):
            p = '/dev/shm/' + f
            if f.startswith('PostgreSQL.') and f not in inuse and os.stat(p).st_uid == os.getuid() \
                    and time.time() - os.stat(p).st_mtime > 300:
                os.unlink(p)
                with open(LOG, 'a') as fh: fh.write(f'{time.ctime()} removed orphan shm {f}\n')
    except OSError:
        pass
    time.sleep(10)
