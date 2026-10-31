items = ", ".join("a" for _ in range(20))
src = "async def f():\n async with (" + items + "): yield 1\n"
compile(src, "<string>", "exec")
print("ok")
