import csv
s12 = '"time","forces"\n1,1.5\n0.5,5+0j\n0,0\n1+1j,6\n'
s13 = '"time","forces"\n0,0\n1,2\na,b\n'
sn = csv.Sniffer()
print(sn.has_header(s12))
print(sn.has_header(s13))
