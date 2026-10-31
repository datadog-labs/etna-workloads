import asyncio, os

loop = object()
task = object()
asyncio._set_running_loop(loop)
asyncio.tasks._enter_task(loop, task)
r, w = os.pipe()
pid = os.fork()
if pid == 0:
    try:
        asyncio._set_running_loop(loop)
        t = asyncio.current_task()
        os.write(w, b'NO TASK' if t is None else b'SHARED TASK')
    except BaseException as e:
        os.write(w, b'ERROR:' + ascii(e).encode())
    finally:
        os._exit(0)
print(os.read(r, 100))
os.waitpid(pid, 0)
