Runs a sleeping child via subprocess.run with timeout=-1 and 0 and prints the
TimeoutExpired message tail. Clean reports the original timeout ("after -1
seconds"/"after 0 seconds"); buggy reports the internal remaining time.
