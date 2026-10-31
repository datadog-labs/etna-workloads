Starts the resource tracker, raw os.fork()s, and has the child report whether its
inherited tracker pipe fd was closed by the at-fork handler (gh-146313).
Clean: True. Buggy: False (child keeps the fd, so the parent's tracker reaping can hang).
