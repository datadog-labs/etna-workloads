Calls enum._iter_bits_lsb(-4). Clean raises ValueError ("-4 is not a positive integer");
buggy lacks the check and yields bits forever (1, 2, 4... for negatives), so it prints a list instead.
(Same root cause makes @verify(NAMED_FLAGS) hang on a negative alias.)
