#!/usr/bin/perl
# Nathalie Tate
# This code is freely available to be modified or distributed under the MIT 
#	License. See LICENSE.txt
#
# populateTables.pl MUST be run before this file.

print("Adding Foreign Key Constraints...\n");

use DBI;

$database='MooCow';

my $dbh = DBI->connect("dbi:mysql:", "root",""
#debug
#, {PrintError => 0,
#RaiseError => 0}
		);

$dbh->do("use $database;");

### Add constraints

$dbh->do("alter table Tracking add foreign key(pkgID) references
	Package(pkgID);");

$dbh->do("alter table Package add foreign key (customerID) references 
	Customer(customerID) on delete cascade;"); 
$dbh->do("alter table Package add foreign key (customsID) references
	CustomsManifest(customsID) on update cascade on delete cascade;");

$dbh->do("alter table Invoice add foreign key (customerID) references
	Customer(customerID) on update cascade on delete cascade;");
$dbh->do("alter table Invoice add foreign key (pkgID) references
	Package(pkgID);");

$dbh->disconnect();

print("Done\n");

exit;
