#!/usr/bin/perl
# Nathalie Tate
# This code is freely available to be modified or distributed under the MIT 
#	License. See LICENSE.txt
#
# createDB.pl MUST be run before this file.

print("Password for SQL user 'root':");
$pw = <>;
$pw = trim($pw);

print("Creating Tables...\n");

sub trim 
{
	$s = shift; 
	$s =~ s/^\s+|\s+$//g; 
	return $s 
};
use DBI;

$database='CSE345nrt';
my $dbh = DBI->connect("dbi:mysql:", "root","$pw"
	, {PrintError => 0,
	RaiseError => 0}
	);

$dbh->do("use $database;");

$dbh->do("create table Customer(customerID integer auto_increment primary key, 
	fName varchar(20), initial char, lName varchar(20), addrLine1 varchar(50), 
	city varchar(50), state varchar(10), zip integer);");

$dbh->do("create table Package(pkgID integer auto_increment primary key, 
	customerID integer, hazardous integer(1), weight integer,
	customsID integer, shipping enum('overnight','express','standard','free'),
	sourceAddr varchar(50), sourceCity varchar(50), sourceState char(2), 
	sourceZip integer, destinationAddr varchar(50), destinationCity varchar(50),
	destinationState char(2), destinationZip integer );"); 

$dbh->do("create table Tracking(date date, pkgID integer,timeToArrival
	varchar(15),courierID varchar(20),currentAddr varchar(50),currentCity
	varchar(50), currentState char(2), currentZip integer);");

$dbh->do("create table Invoice(pkgID integer, 
	accountNum integer, customerID integer, amntDue float, payment float, date 
	date, dueDate date, creditOrShipping enum('credit', 'shipping account'));");

$dbh->do("create table CustomsManifest(customsID integer primary key
	auto_increment, contents varchar(30), value float);");


### Add constraints
$dbh->do("alter table Tracking add primary key(pkgID, date);");

#$dbh->do("alter table Tracking add primary key(pkgID, date);");
#$dbh->do("alter table Tracking add foreign key(pkgID) references
#Package(pkgID);");
#
#$dbh->do("alter table Package add foreign key (customerID) references 
#Customer(customerID) on delete cascade;"); 
#$dbh->do("alter table Package add foreign key (customsID) references
#CustomsManifest(customsID) on update cascade on delete cascade;");

#$dbh->do("alter table Invoice add foreign key (customerID) references
#	Customer(customerID) on update cascade on delete cascade;");
#$dbh->do("alter table Invoice add foreign key (pkgID) references
#Package(pkgID);");

$dbh->disconnect();

print("Done\n");

exit;
