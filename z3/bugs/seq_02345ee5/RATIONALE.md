# Rationale
Changed hunk: src/src/ast/ast_smt_pp.cpp, smt_printer::visit_app: removed the `else if (m_sutil.str.is_string(n, s))` branch.
Traces to FIX.diff hunk in ast_smt_pp.cpp adding `else if (m_strutil.is_string(n,&str)) m_out << "\"" << str << "\""`.
Without it string constants print as `(_ String abc)`, which the parser can't read back, so the spec1 loopback in smt2print_parse fails ("unknown function abc").
Other fix hunks (trace output, parser buffer copy, is_string helper) were already superseded or are not behavioural in current code.

Final check.sh result:
FAIL smt2print_parse (rc=1)
