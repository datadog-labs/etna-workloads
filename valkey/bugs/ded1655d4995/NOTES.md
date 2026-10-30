Adds three points near Sicily and runs GEOSEARCH BYBOX with width 400 km / height 2 km (and the swapped form).
Clean build returns test1 for 400x2 and nothing for 2x400; the buggy build swaps width and height, so the results are reversed.
