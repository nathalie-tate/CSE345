Dependencies:
perl
java
java-dbi
mysql/mariadb

CPAN Packages:

 DBI 
 DBI::MySQL 
 Math::Random 


Instructions:
	1) Start the MySQL server. This step will depend on your operating system and
		 your MySQL implementation. For Linux with Systemd using MariaDB, the 
		 correct command is `sudo systemctl start mariadb.service'. 

	2) Execute runAll.pl `./runAll.pl' on linux, `perl runall.pl' on linux or
		 windows. This will create and populate the database and tables. Skip step 3

	3) ALTERNATELY: run the creation scripts manually. They MUST be run in the 
		 following order: createDB.pl, createTables.pl, populateTables.pl,
		 addConstraints.pl. 

	4) #TODO
