SELECT a.value, b.value FROM generate_series a CROSS JOIN generate_series b ON b.start=a.value AND b.stop=a.value WHERE a.start=1 AND a.stop IN (2,3);
