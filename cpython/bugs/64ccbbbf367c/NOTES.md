Creates a zipapp whose target lives inside the source dir and prints the archive's names.
Clean: ['__main__.py', 'test.py']. Buggy: the archive also contains 'target.pyz' (self-insertion), since the buggy filter check compares the wrong paths.
