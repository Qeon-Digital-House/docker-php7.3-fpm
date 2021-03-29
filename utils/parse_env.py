#!/usr/bin/env python3
# Read .env file and split it to key and value, separated by new line.
import shlex
import sys

try:
    filename = sys.argv[1]
except:
    print("Specify an input .env file.", file=sys.stdout)
    sys.exit(1)

with open(filename, "r") as fp:
    while True:
        temp = fp.readline()

        if not temp:
            break

        temp = temp.strip()

        if temp.startswith("#") or not "=" in temp or not temp:
            continue

        temp_key, temp_val = temp.split("=", 1)
        temp_val = shlex.split(temp_val)

        if not temp_val:
            temp_val = [""]
        print(temp_key)
        print(temp_val[0])
