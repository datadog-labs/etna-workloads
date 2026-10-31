import subprocess, sys, os

code = """if 1:
    import gc, os
    for i in range(50):
        exec(compile(f"def _dummy_{i}(): pass", f"<test{i}>", "exec"))
    pid = os.fork()
    if pid == 0:
        for i in range(50):
            exec(compile(f"def _child_{i}(): pass", f"<child{i}>", "exec"))
        gc.collect()
        os._exit(0)
    _, status = os.waitpid(pid, 0)
    print("signaled:", os.WIFSIGNALED(status), "exit:", os.WEXITSTATUS(status) if os.WIFEXITED(status) else None)
"""
p = subprocess.run([sys.executable, "-Xperf", "-c", code], capture_output=True, text=True,
                   env={**os.environ, "PYTHON_JIT": "0"})
print(p.returncode)
print(p.stdout)
print(p.stderr[-300:])
