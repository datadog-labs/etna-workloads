repro.py: an asyncio start_server callback drops its StreamWriter and calls gc.collect(), printing the ResourceWarnings raised.

- Clean: prints `['unclosed <StreamWr']`, exit 0.
- Buggy: prints `[]`, because the protocol keeps a strong reference (`_stream_writer`), so the writer isn't collected and no warning fires. It also emits unclosed-transport warnings at exit.
