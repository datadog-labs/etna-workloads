Reproducer: copy/deepcopy/pickle of a super object. Clean returns super objects (shallow copy is the same object); buggy copies/pickles the underlying instance instead.
