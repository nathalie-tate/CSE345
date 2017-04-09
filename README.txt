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
		 takes a very long time, so importing is preferred. 
		 
		 2.1) IMPORTRING

		 		 2.1.1)	LINUX: skip to step 3 and follow the instructions for importing. 
				 				This requires root access. If you do not have root access, skip
								to step 2.2.1.

				 2.1.2) WINDOWS: you'll have to manually import the database. I do not
				 				know how to do this in Windows, but I'm sure it's possible.

		 2.2) GENERATING THE DATABASE

				 2.2.1) LINUX: Execute runAll.sh. This will create and populate the
							  database and tables.

				 2.2.2) WINDOWS: The generation scripts do not work correctly on 
				 				Windows. You will need to import the example database. See
								Section 2.1.2.
				 				
	3) Run interface.pl to use the application.  
