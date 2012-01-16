#!/usr/bin/python

import sys

last = set()
for line in sys.stdin:
    if line in last:
        continue
    else:
        last.add(line)
        sys.stdout.write(line)
