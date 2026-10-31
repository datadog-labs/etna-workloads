Reproducer: ArgumentParser with a custom HelpFormatter subclass whose __init__ only accepts `prog`, then format_help().
Clean: prints the help text. Buggy: _get_formatter passes prefix_chars/color kwargs -> TypeError.
