import sys
import _colorize
print(sorted({"copy", "re", "inspect", "typing"} & set(sys.modules)))
