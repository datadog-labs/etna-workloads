SELECT hashfloat4('NaN'::float4) = hashfloat4(-'NaN'::float4) AS t4;
SELECT hashfloat8('NaN'::float8) = hashfloat8(-'NaN'::float8) AS t8;
