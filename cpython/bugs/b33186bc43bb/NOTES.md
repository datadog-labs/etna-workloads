Calls EmailMessage.set_content with ASCII bytes and cte='7bit'. Clean prints the message;
buggy leaves bytes as payload (AttributeError: 'bytes' object has no attribute 'encode'/str failure).
