from email import _header_value_parser as parser
from email import policy

prefix = "0123456789 " * 5
for s in ["=?unknown-8bit?q?=A4?=\xa4",
          prefix + "=?unknown-8bit?q?=A4?=abc",
          "\xa4=?unknown-8bit?q?=A4?="]:
    print(repr(parser.get_unstructured(s).fold(policy=policy.default)))
