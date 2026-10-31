import threading

class BooleanTarget:
    def __init__(self):
        self.ran = False
    def __bool__(self):
        return False
    def __call__(self):
        self.ran = True

target = BooleanTarget()
t = threading.Thread(target=target)
t.start()
t.join()
print(target.ran)
