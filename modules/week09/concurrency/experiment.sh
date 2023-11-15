#!/bin/bash

# Usage: experiment.sh [wt]
#    wt = with transactions

DBFILE=concurrency.db
WITH_TRANSACTIONS=$1

sqlite3 $DBFILE 'UPDATE my_table SET value = 0' 2> /dev/null

python worker.py 500 1 $WITH_TRANSACTIONS &
python worker.py 500 -1 $WITH_TRANSACTIONS &
wait %1 %2

echo "value = $(sqlite3 -csv $DBFILE 'SELECT * FROM my_table' 2> /dev/null)"
