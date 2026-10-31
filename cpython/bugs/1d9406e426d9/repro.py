import cmd, readline

class C(cmd.Cmd):
    def completedefault(self, text, line, begidx, endidx):
        return ["hello"]

for line in ["! h", "!h"]:
    readline.get_line_buffer = lambda line=line: line
    readline.get_begidx = lambda line=line: line.index("h")
    readline.get_endidx = lambda line=line: len(line)
    c = C()
    c.completion_matches = None
    print(repr(line), c.complete("h", 0))
