repro.py runs `python -q -m asyncio` with empty stdin and checks whether the banner is printed. Clean (fixed): no banner (False). Buggy: banner printed despite -q (True).
