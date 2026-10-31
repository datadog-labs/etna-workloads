from profiling.sampling.live_collector import LiveStatsCollector

class T:
    thread_id = 123
    frame_info = []
    status = 0

class I:
    interpreter_id = 0
    threads = [T()]

c = LiveStatsCollector(1000)
c.collect([I()])
print(c.total_samples, c.successful_samples, c.failed_samples)
