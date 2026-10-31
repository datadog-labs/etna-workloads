from concurrent.futures import InterpreterPoolExecutor

with InterpreterPoolExecutor(max_workers=1) as ex:
    print(ex._thread_name_prefix)
