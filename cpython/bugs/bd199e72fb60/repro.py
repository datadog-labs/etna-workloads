class ModelBase(type):
    def __new__(cls, name, bases, attrs):
        new_class = super().__new__(cls, name, bases, {})
        if name != "Model":
            raise RuntimeWarning(f"{name=}")
        return new_class

class Model(metaclass=ModelBase):
    pass

try:
    type("SouthPonies", (Model,), {})
except RuntimeWarning as e:
    print("RuntimeWarning", e)
