import _interpreters
import types

interp = _interpreters.create(
    types.SimpleNamespace(
        use_main_obmalloc=False,
        allow_fork=False,
        allow_exec=False,
        allow_threads=True,
        allow_daemon_threads=True,
        check_multi_interp_extensions=True,
        gil='own',
    )
)
_interpreters.exec(interp, """if True:
    import threading
    import time

    def task():
        time.sleep(3)

    threads = (threading.Thread(target=task, daemon=True) for _ in range(3))
    for t in threads:
        t.start()
    """)
_interpreters.destroy(interp)
print("done")
