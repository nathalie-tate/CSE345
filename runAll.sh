#!/usr/bin/sh

perl createDB.pl
sleep 1
perl createTables.pl
sleep 1
perl populateTables.pl
