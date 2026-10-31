from profiling.sampling.heatmap_collector import HeatmapCollector

def frame(filename, line, func):
    return (filename, (line, line, -1, -1), func, None)

c = HeatmapCollector(sample_interval_usec=100)
for line in (12, 15, 10):
    c.process_frames([frame('mod.py', line, 'my_func'),
                      frame('caller.py', 100, 'caller')], thread_id=1)
c.file_index['caller.py'] = 'caller.html'
# interior line 15 should still show who calls my_func
print(c._build_navigation_buttons('mod.py', 15))
