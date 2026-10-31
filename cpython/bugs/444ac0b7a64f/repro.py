import inspect, operator
print(inspect.signature(operator.attrgetter('x')))
print(inspect.signature(operator.itemgetter(1)))
print(inspect.signature(operator.methodcaller('f')))
