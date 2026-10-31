import contextvars
var = contextvars.ContextVar("v")
ctx1 = contextvars.Context()
ctx2 = contextvars.Context()

class ReentrantEq:
    def __eq__(self, other):
        ctx1.run(lambda: var.set(object()))
        return True

ctx1.run(var.set, ReentrantEq())
ctx2.run(var.set, object())
print(ctx1 == ctx2)
