# Usage: python worker.py num_reps delta [wt]
#    wt = with transactions

import random
import sqlite3
import sys
import time

num_reps = int(sys.argv[1])
delta = int(sys.argv[2])
with_transactions = (len(sys.argv) >= 4 and sys.argv[3] == "wt")

rng = random.SystemRandom()

conn = sqlite3.connect("concurrency.db", isolation_level=None)
c = conn.cursor()

for _ in range(num_reps):
    if with_transactions:
        c.execute("BEGIN IMMEDIATE")
    value = c.execute("SELECT value FROM my_table").fetchone()[0]
    time.sleep(rng.random()*.025)
    value += delta
    c.execute("UPDATE my_table SET value = ?", (value,))
    if with_transactions:
        c.execute("COMMIT")
    time.sleep(rng.random()*.025)
