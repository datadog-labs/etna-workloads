import atexit

def f1(): log.append(1)
def f2(): log.append(2)
def f3(): log.append(3)

class Pred:
    def __eq__(self, other):
        global cnt
        cnt += 1
        if cnt == when:
            atexit.unregister(what)
        return other is f2

for what in (f1, f2, f3):
    for when in range(1, 4):
        cnt = 0
        log = []
        for f in (f1, f2, f3):
            atexit.register(f)
        atexit.unregister(Pred())
        atexit._run_exitfuncs()
        print(what.__name__, when, log)
