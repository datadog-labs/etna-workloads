from concurrent.futures import InterpreterPoolExecutor

def func():
    import _datetime
    print('a', end='')

with InterpreterPoolExecutor() as executor:
    for _ in range(8):
        executor.submit(func)
