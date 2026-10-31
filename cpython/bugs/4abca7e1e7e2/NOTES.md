Calls subprocess.run(..., stdout=subprocess.STDOUT). Clean raises
ValueError("STDOUT can only be used for stderr"); the buggy build lacks that check and
fails differently (or runs the child), so output differs.
