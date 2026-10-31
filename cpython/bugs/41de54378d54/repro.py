class CustomFormat:
    def __format__(self, format_spec):
        return format_spec

print(repr(f'{CustomFormat():\n}'))
print(repr(f'{CustomFormat():☃}'))
