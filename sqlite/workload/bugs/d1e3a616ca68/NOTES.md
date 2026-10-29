`repro.sql` trims the UTF-8 string "αβγ" (blob ceb1ceb2ceb3) with the trim set "α" (ceb1).
Clean: CEB2CEB3 (trim removes whole characters, so "βγ" remains).
Buggy: B2CEB3 (trim works bytewise and strips only the first byte, cutting the character in half).
