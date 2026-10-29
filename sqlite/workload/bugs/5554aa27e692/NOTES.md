Runs a query in HTML output mode on a value containing `>`.
Clean shell outputs `ab&gt;cd`; buggy shell outputs `ab&lt;cd` (wrong HTML escaping of `>`).
