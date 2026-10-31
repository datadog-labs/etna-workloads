Reproducer uses a Random subclass with scripted random() values and calls gammavariate(1.0, 3.14).
Clean: result is -log(1-u)*beta (matches expovariate; 1.8772... for u=0.45).
Buggy: uses -log(u)*beta and rejects u <= 1e-7 (2.5073... for 0.45; StopIteration on 1e-8 as it re-draws).
