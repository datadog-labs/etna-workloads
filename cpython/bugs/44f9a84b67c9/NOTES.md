Reproducer for the pdb `;;` command-queue ordering bug (gh-90095).
It runs `python -m pdb main.py` with a .pdbrc containing `commands 1 ;; p a;; end`.
Clean: the queued commands run in order, so `p a` prints `<__main__.A object at ...>`.
Buggy: precmd appends rather than inserts at the front of cmdqueue, so the order is
scrambled and the object is never printed. The script prints True on clean, False on buggy.
