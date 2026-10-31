class C:
    pass

print('__firstlineno__' in vars(C))
C.__module__ = 'other'
print('__firstlineno__' in vars(C))
