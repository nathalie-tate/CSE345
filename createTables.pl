#!/usr/bin/perl
# Nathalie Tate
# This code is freely available to be modified or distributed under the MIT 
#	License. See LICENSE.txt
#
# createDB.pl MUST be run before this file.

use DBI;

$database='MooCow';

my $dbh = DBI->connect("dbi:mysql:", "root",""
#debug
#, {PrintError => 0,
#RaiseError => 0}
		);

$dbh->do("use $database;");

$dbh->do("create table Customer(fName varchar(20), lName varchar(20), initial
	char, address varchar(30), accountNum integer, customerID integer
	auto_increment primary key);");

$dbh->do("create table Package(pkgID integer auto_increment primary key, 
	customerID integer, trackingNum integer, hazardous boolean, 
	customsID integer, destination varchar(30));");

$dbh->do("create table Tracking(date date, trackingNum integer,
	timeToArrival varchar(15), currentLocation varchar(20));");

$dbh->do("create table Invoice(invoiceNum integer, accountNum 
	integer primary key, amntDue float, payment float, date date, dueDate date,
	creditOrShipping enum('credit', 'shipping account'));");

$dbh->do("create table CustomsManifest(customsID integer primary key, contents
	varchar(30), value float);");

$dbh->do("create table Pricing(customerID integer, pkgNum integer, price
	float);");

### Add constraints

$dbh->do("alter table Tracking add primary key(trackingNum, date);");

$dbh->do("alter table Customer add foreign key(accountNum) references
	Invoice(accountNum);");

$dbh->do("alter table Package add foreign key (customerID) references 
	Customer(customerID) on delete cascade;");

$dbh->do("alter table Package add foreign key (trackingNum) references
	Tracking(trackingNum) on update cascade on delete cascade;");

$dbh->do("alter table Package add foreign key (customsID) references
	CustomsManifest(customsID) on update cascade on delete cascade;");

$dbh->do("alter table Pricing add foreign key(customerID) references
	Customer(customerID) on update cascade on delete cascade;");

$dbh->do("alter table Pricing add foreign key(pkgNum) references Package(pkgID) 
	on update cascade on delete cascade;");

$dbh->disconnect();
exit;
