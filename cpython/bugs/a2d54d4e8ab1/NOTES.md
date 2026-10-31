repro.py calls colorsys.rgb_to_hls(0.9999999999999999, 1, 1) (gh-106498). Clean: (0.5, 1.0, 1.0). Buggy: ZeroDivisionError because 2.0-sumc is 0.
