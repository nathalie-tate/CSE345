Dependencies:
perl
java
MySQL/mariadb
MySQL Connector/mariadb-jdbc

CPAN Packages:

 DBI 
 DBI::MySQL 
 Math::Random 


Instructions:
	0) Install the required dependencies. Java, a mysql implementation, and 
		 a jdbc implementation are MANDATORY. Perl and the required CPAN packages
		 are required for creating and populating the database, but not for the 
		 application

	1) Start the MySQL server. This step will depend on your operating system and
		 your MySQL implementation. For Linux with Systemd using MariaDB, the 
		 correct command is `sudo systemctl start mariadb.service'. 

	2) LINUX: Execute runAll.pl `./runAll.sh'. This will create and populate
		 the database and tables. Skip step to step 6

	3) WINDOWS: Execute runAll.bat (how?? TODO)
		 Skip to step 6.

	4) ALTERNATELY: run the creation scripts manually. They MUST be run in the 
		 following order: createDB.pl, createTables.pl, populateTables.pl,
		 addConstraints.pl. 

	5) ALTERNATELY, AGAIN: use the exported sample database. Skip to step 6

	6)
