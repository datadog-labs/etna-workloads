Directly instantiates argparse.HelpFormatter and formats a usage line. Clean prints 'usage: program
'; buggy raises AttributeError (_cached_theme missing) since __init__ no longer calls _set_color(False).
