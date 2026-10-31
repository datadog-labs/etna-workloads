import asyncio

async def main():
    stream = asyncio.StreamReader()
    stream.feed_data(b'some data\r\n')
    try:
        data = await stream.readuntil(bytearray(b'\r\n'))
        print(repr(data), repr(bytes(stream._buffer)))
    except Exception as e:
        print(type(e).__name__, e)

asyncio.run(main())
