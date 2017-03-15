#!/usr/bin/perl
# Nathalie Tate
# This code is freely available to be modified or distributed under the MIT 
#	License. See LICENSE.txt
#
# This file must be run after createDB.pl

use DBI;

$database='MooCow';

my $dbh = DBI->connect("dbi:mysql:", "root",""
#, {PrintError => 0,
#RaiseError => 0}
		);

$dbh->do("use $database;");

$dbh->do("create table Customer(fName varchar(20)not null, lName varchar(20)not
	null, initial char, address varchar(30)not null , accountType 
	enum('credit', 'shipper')not null, accountNum varchar(15)not null, customerID
	integer auto_increment primary key);");

$dbh->do("create table Package(pkgID integer auto_increment primary key, 
	customerID integer, trackingNum integer, hazardous boolean, 
	customsID integer, destination varchar(30));");

$dbh->do("create table Tracking(date date, trackingNum integer,
	timeToArrival varchar(15), currentLocation varchar(20));");

$dbh->do("create table CreditCardAccount();");

$dbh->disconnect();
exit;
