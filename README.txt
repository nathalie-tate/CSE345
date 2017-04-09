Dependencies:
perl
MySQL/mariadb

CPAN Packages:

 DBI 
 DBI::MySQL 
 Math::Random 


Instructions:
	0) Install the required dependencies.

		0.1) On Unix-like systems, install Perl and the requisite packages through
				 your package manager. On Windows, Perl can be downloaded from 
				 http://strawberryperl.com. The CPAN packages can be installed by 
				 entering the following commands into the command prompt:
				 $ perl -MCPAN -e shell
				 $ install <PACKAGE NAME>

	1) Start the MySQL server. This step will depend on your operating system and
		 your MySQL implementation. For Linux with Systemd using MariaDB, the 
		 correct command is `sudo systemctl start mariadb.service'. 

	2) You must either generate or import the database. Generating the database
		 takes a very long time, so importing is preferred. On Unix-like systems,
		 run interface.pl (perl interface.pl) and follow the instructions for 
		 importing. On Windows, you must generate the Database.

	3) GENERATING THE DATABASE
	
		3.1) LINUX: Execute runAll.sh `./runAll.sh'. This will create and populate
				 the database and tables. Skip step to step ?

		3.2) WINDOWS or LINUX: run the creation scripts manually. They MUST be run
				 in the following order: createDB.pl, createTables.pl,
				 populateTables.pl.  
				
	6) Run interface.pl to use the application.
