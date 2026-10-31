Calls locale.normalize on "c.utf8" and "C.UTF-8".
Clean prints C.UTF-8 twice; buggy prints en_US.UTF-8 (alias table maps c.utf8 wrongly).
