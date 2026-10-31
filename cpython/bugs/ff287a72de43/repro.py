import io, wave
with wave.open(io.BytesIO(), 'wb') as f:
    f.setnchannels(1)
    f.setsampwidth(2)
    try:
        f.setframerate(0.4)
        print("accepted")
    except wave.Error as e:
        print("Error:", e)
    try:
        f.close()
    except wave.Error as e:
        print("close Error:", e)
