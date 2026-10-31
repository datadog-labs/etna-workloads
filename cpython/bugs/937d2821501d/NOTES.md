Reproducer: csv.reader/csv.writer with delimiter=' ' and skipinitialspace=True.
Clean: reader returns [['a','b'],['a',''],[''],[]] and writer emits '"" ""\r\n'.
Buggy: both raise ValueError("bad delimiter value"), since the combination is rejected.
