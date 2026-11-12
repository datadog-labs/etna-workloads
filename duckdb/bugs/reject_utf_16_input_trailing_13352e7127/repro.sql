.mode list
.nullvalue NULL
FROM read_csv('data/csv/encodings/utf16_odd_length.csv', encoding = 'utf-16', header = false);
