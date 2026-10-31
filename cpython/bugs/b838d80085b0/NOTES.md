repro.py defines an Enum with a plain-function _generate_next_value_ and prints the type stored in the class __dict__. Clean: staticmethod. Buggy: function (enum no longer wraps it in staticmethod).
