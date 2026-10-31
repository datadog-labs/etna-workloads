import random
from unittest import mock

with mock.patch.object(random.Random, 'random', side_effect=[0.0] + [0.5] * 20):
    result = random.binomialvariate(10, 0.5)
    print(repr(result), result in range(11))
