import io, wave

out = io.BytesIO()
with wave.open(out, 'wb') as w:
    w.setnchannels(1)
    w.setsampwidth(1)
    w.setframerate(48000)
    w.writeframes(b'\x80')
value = out.getvalue()
print(len(value), value[-1], int.from_bytes(value[4:8], 'little'))
