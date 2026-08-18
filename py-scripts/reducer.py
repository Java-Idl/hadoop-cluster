#!/usr/bin/env python3
import sys

current_word = None
current_count = 0

# Read sorted key-value pairs from standard input
for line in sys.stdin:
    line = line.strip()
    if not line:
        continue

    try:
        word, count = line.split("\t", 1)
        count = int(count)
    except ValueError:
        continue

    # Hadoop sorts keys; if key matches, accumulate count
    if current_word == word:
        current_count += count
    else:
        # Emit aggregated result for previous key
        if current_word is not None:
            print(f"{current_word}\t{current_count}")
        current_word = word
        current_count = count

# Emit the final key's count
if current_word is not None:
    print(f"{current_word}\t{current_count}")
