import subprocess, sys, time
from _remote_debugging import RemoteUnwinder

child = r'''
import asyncio, threading, time

async def worker_main():
    task = asyncio.create_task(asyncio.sleep(10_000), name="worker task")
    await asyncio.sleep(0)
    print("ready", threading.get_native_id(), flush=True)
    await task

threading.Thread(target=lambda: asyncio.run(worker_main()), daemon=True).start()
time.sleep(10_000)
'''

p = subprocess.Popen([sys.executable, "-c", child], stdout=subprocess.PIPE, text=True)
try:
    tid = int(p.stdout.readline().split()[1])
    found = False
    for _ in range(50):
        try:
            res = RemoteUnwinder(p.pid).get_all_awaited_by()
        except RuntimeError:
            time.sleep(0.1)
            continue
        found = any(t.task_name == "worker task"
                    for i in res if i.thread_id == tid for t in i.awaited_by)
        if found:
            break
        time.sleep(0.1)
    print("worker task found:", found)
finally:
    p.kill()
    p.wait()
    p.stdout.close()
