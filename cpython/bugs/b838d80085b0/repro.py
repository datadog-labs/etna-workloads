import enum

class Lazy(enum.Enum):
    def _generate_next_value_(name, start, count, last_values):
        return name

print(type(Lazy.__dict__['_generate_next_value_']).__name__)
