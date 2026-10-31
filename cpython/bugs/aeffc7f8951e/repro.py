import glob
open('EF', 'w').close()
print(sorted(glob.glob('EF/**', recursive=True)))
print(sorted(glob.glob('nonexistent/**', recursive=True)))
