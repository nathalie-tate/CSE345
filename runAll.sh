#!/usr/bin/sh

perl createDB.pl
perl createTables.pl
perl populateTables.pl
perl addConstraints.pl
