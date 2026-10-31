Creates a DocXMLRPCServer, sets the title to `test_title<script>`, and prints the `<title>` element of the generated docs.
Clean: `<title>Python: test_title&lt;script&gt;</title>` (escaped). Buggy: the title is unescaped (`<script>` raw).
