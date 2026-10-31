Reproducer: shutil.rmtree on a FIFO. Clean opens with O_NONBLOCK and raises NotADirectoryError; buggy blocks in open() (alarm turns it into TimeoutError 'blocked').
