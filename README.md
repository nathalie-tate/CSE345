# CSE 345 Project

## Todo:
diagrams/design

client  (java, javascript?)

server  (perl)

## Dependencies:
perl

perl-dbi

perl-dbd-mysql

mysql/mariadb

# createDB.pl
This script will create the database. If the database already exists, it will 
delete it first.

MySQL server **MUST** be running.

# createTables.pl
This script will create the tables in the database. createDB.pl **MUST** be run
first

# populateTables.pl
This script will populate the tables in the database. createTables.pl **MUST**
be run first
