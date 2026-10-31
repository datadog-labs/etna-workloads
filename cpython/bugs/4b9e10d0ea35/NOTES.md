repro.py drives a _pyrepl ReadlineAlikeReader with a fake console: enter "import os",
then type "imp" and press page-up (history search backward), then Enter.
The returned text is the same, but the final rendered screen differs:
clean: ['>>> import os']; buggy: ['>>> imp', 'ort os'] (stale screen,
because select_item calls invalidate_buffer(self.pos) instead of invalidate_buffer(0)).
