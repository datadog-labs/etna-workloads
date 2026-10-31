Creates a real UDP endpoint via asyncio and checks that the transport is an
asyncio.DatagramTransport. Clean prints True; buggy prints False because
_SelectorDatagramTransport no longer inherits from transports.DatagramTransport.
