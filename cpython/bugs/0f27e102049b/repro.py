import os, tempfile, zoneinfo

with tempfile.TemporaryDirectory() as td:
    for key in ["America/New_York", "Europe/London", "localtime"]:
        path = os.path.join(td, key)
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "wb") as f:
            f.write(b"TZif" + b"\0" * 100)
    zoneinfo.reset_tzpath(to=[td])
    print(sorted(zoneinfo.available_timezones()))
