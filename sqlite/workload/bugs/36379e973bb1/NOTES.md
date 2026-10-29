Reproducer: aggregate aliased with AS (`min(a) AS m`) used inside another aggregate in HAVING (`max(m+5)`).
Clean shell reports "misuse of aliased aggregate m"; the buggy shell lacks that check (different result/error/assert).
