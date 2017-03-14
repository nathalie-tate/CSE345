#!/usr/bin/perl
# Nathalie Tate
# This code is freely available to be modified or distributed under the MIT 
#	License. See LICENSE.txt

use DBI;

$database='MooCow';

my $dbh = DBI->connect("dbi:mysql:", "root",""
		, {PrintError => 0,
		RaiseError => 0}
		);

$dbh->do("use $database");

$dbh->do("create table TABLENAME values ()");

$dbh->disconnect();
exit;
