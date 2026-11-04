select encode(X'8f50d3f60eae370ddbf85c86219c55108a350165', 'hex');
select encode(digest('hello', 'sha256'), 'hex');
select encode(X'8f50d3f60eae370ddbf85c86219c55108a350165', 'base64');
select arrow_typeof(encode(X'8f50', 'hex'));
