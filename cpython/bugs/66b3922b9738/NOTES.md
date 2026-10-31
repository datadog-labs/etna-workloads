Parses `--color yellow` with a StrEnum `choices` and prints the ArgumentError.
Clean: `invalid choice: 'yellow' (choose from 'red', 'green')`.
Buggy: choices are formatted with repr of the enum members, giving `<Color.RED: 'red'>, ...`.
