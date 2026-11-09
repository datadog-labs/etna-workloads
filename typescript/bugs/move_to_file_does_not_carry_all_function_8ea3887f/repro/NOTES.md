Input: a file with two function overload signatures plus an implementation; the language service is asked for "Move to a new file" with the selection covering only the first overload.
Clean: all three declarations (both overloads and the implementation) are moved to the new file `add.ts`.
Injected: only the selected first overload is moved, leaving the other signatures and the implementation behind.
