import argparse
from enum import StrEnum

class Color(StrEnum):
    RED = "red"
    GREEN = "green"

parser = argparse.ArgumentParser(exit_on_error=False)
parser.add_argument('--color', choices=Color)
try:
    parser.parse_args(['--color', 'yellow'])
except argparse.ArgumentError as e:
    print(e)
