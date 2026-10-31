import time
from profiling.sampling.live_collector import LiveStatsCollector, MockDisplay

display = MockDisplay(height=40, width=160)
c = LiveStatsCollector(1000, pid=12345, display=display)
c.start_time = time.perf_counter()

display.simulate_input(ord("h"))
c._handle_input()
print("show_help after h:", c.show_help)
display.simulate_input(ord("q"))
c._handle_input()
print("show_help after q:", c.show_help)
print("running:", c.running)
