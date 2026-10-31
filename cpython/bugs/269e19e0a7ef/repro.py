from concurrent import interpreters

count = 0

def get_count():
    return count

if __name__ == "__main__":
    interp = interpreters.create()
    print(interp.call(get_count))
    interp.exec("import __main__; print('get_count' in vars(__main__), 'count' in vars(__main__))")
