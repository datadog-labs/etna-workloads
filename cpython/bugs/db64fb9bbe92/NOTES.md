Calls subprocess.check_output(input=None, encoding='utf-8', errors='ignore').
Clean: prints 'foo\n'. Buggy: input=None is replaced by b'' (not '') when only
encoding/errors are given, so it raises AttributeError ("bytes" has no "encode") instead of returning output.
