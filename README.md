# CSE 345 Project

## Dependencies:
perl

CPAN Packages:

- DBI 
- DBI::MySQL 
- Math::Random 

mysql/mariadb

# runAll.sh
It you're running Linux, this script will set up the entire database for you.
You can run this once and forget about the rest of the scripts!  

# createDB.pl
This script will create the database. If the database already exists, it will 
delete it first.

MySQL server **_MUST_** be running.

# createTables.pl
This script will create the tables in the database. createDB.pl **MUST** be run
first

# populateTables.pl
This script will populate the tables in the database. createTables.pl **MUST**
be run first

**_Important:_** This must be run _exactly_ once. Running this script multiple
times will create database errors that will not be caught.

# addConstraints.pl
Creates foreign key constraints on the database. **Must** be run after 
populateTables.pl
