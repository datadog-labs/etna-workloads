def get_code(n):
    code = "async def bug():\n    async with (\n    a\n"
    for i in range(n):
        code += f"    as a{i}, a\n"
    return code + "): yield a"

for n in range(17, 26):
    try:
        compile(get_code(n), "<string>", "exec")
        print(n, "ok")
    except SyntaxError as e:
        print(n, e.msg)
