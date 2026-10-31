import subprocess, sys, time
import _remote_debugging

N, R = 20, 150
lines = ['import sys', 'sys.setrecursionlimit(5000)']
for i in range(N - 1):
    lines += [f'def c{i}(n):', f'    yield n', f'    yield from c{i+1}(n)']
lines += [f'def c{N-1}(n):', '    yield n', f'    yield from dive(n, {N})',
          'def dive(n, d):', '    yield n', f'    if d < {R}:', '        yield from dive(n, d + 1)',
          '    else:', '        for i in range(5):', '            yield i',
          'def osc(k):', '    for i in range(k):', '        yield i', '        yield from c0(i)',
          'def run_forever():', '    while True:', '        for _ in osc(10):', '            pass',
          'print("go", flush=True)', 'run_forever()']
p = subprocess.Popen([sys.executable, '-c', '\n'.join(lines)], stdout=subprocess.PIPE)
try:
    p.stdout.readline()
    u = _remote_debugging.RemoteUnwinder(p.pid, all_threads=True, cache_frames=True)
    bad = total = 0
    end = time.time() + 3
    while time.time() < end:
        try:
            info = u.get_stack_trace()
        except Exception:
            continue
        for t in [t for i in info for t in i.threads]:
            fr = t.frame_info
            if fr:
                total += 1
                if fr[-1].funcname != '<module>':
                    bad += 1
    print("enough samples:", total > 100)
    print("incomplete stacks seen:", bad > 0)
finally:
    p.kill(); p.wait(); p.stdout.close()
