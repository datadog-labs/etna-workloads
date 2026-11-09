Imports a JSON file (default import, no import attribute) from an .mts file under `--module node16`.
Clean: no error, since node16 doesn't support import attributes so none is required (only node18+/nodenext require `with {type: "json"}`).
Injected: reports error TS2880-style "Importing a JSON file into an ECMAScript module requires a 'type: "json"' import attribute when 'module' is set to 'Node16'".
