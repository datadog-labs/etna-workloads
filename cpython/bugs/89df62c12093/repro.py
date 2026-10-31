async def afunc():
    async for letter in aiter("abc"):
        pass

print(list(afunc.__code__.co_branches()))
