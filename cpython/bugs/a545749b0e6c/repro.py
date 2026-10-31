import asyncio

async def main():
    running = asyncio.get_running_loop()
    loop = asyncio.new_event_loop()
    try:
        loop.run_forever()
    except RuntimeError as e:
        print("RuntimeError:", e)
    loop.close()
    print(asyncio.get_running_loop() is running)

asyncio.run(main())
