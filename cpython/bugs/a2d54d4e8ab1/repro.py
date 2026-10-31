import colorsys
try:
    print(colorsys.rgb_to_hls(0.9999999999999999, 1, 1))
except ZeroDivisionError as e:
    print("ZeroDivisionError", e)
