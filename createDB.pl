#!/usr/bin/perl

use DBI;

$database='MooCow';

my $dbh = DBI->connect("dbi:mysql:", "root",""
		, {PrintError => 0,
		RaiseError => 0}
		);

$dbh->do("drop database $database");

print 1 == $dbh->do("create database $database") ? "Successfully Created DB '$database'\n":
	"Failed to Create DB '$database'\n";
