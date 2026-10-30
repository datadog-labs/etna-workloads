Starts one server, runs HINCRBYFLOAT with an `inf` increment on an existing hash field, plus a few related commands.
Clean build replies "ERR value is NaN or Infinity"; the buggy build replies "ERR increment would produce NaN or Infinity".
