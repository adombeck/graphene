import sys
import os

if len(sys.argv) > 1:
  dir_ = sys.argv[1]
else:
  dir_ = "."

for f in os.listdir(dir_):
  print(f)
