input.ts uses a legacy octal literal (`010`).
Clean tsc reports error TS1121 "Octal literals are not allowed. Use the syntax '0o10'" and exits 2.
Injected tsc reports no diagnostic and exits 0.
