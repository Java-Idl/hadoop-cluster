#!/usr/bin/env python3
import sys

# Read each line from standard input
for line in sys.stdin:
    # Clean leading/trailing whitespace
    line = line.strip()
    # Split the line into individual words
    words = line.split()
    
    # Emit intermediate key-value pairs (word, 1)
    for word in words:
        print(f"{word}\t1")
