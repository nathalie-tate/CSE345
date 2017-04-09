#!/usr/bin/perl
# Nathalie Tate
# This code is freely available to be modified or distributed under the MIT 
#	License. See LICENSE.txt

use DBI;

sub trim 
{
	$s = shift; 
	$s =~ s/^\s+|\s+$//g; 
	return $s 
};

$database='CSE345nrt';

print("Password for SQL user 'root':");
$pw = <>;
$pw = trim($pw);

my $dbh = DBI->connect("dbi:mysql:", "root","$pw"
	, {PrintError => 0,
	RaiseError => 0}
	);


$dbh->do("drop database $database");

print 1 == $dbh->do("create database $database") ? "Successfully Created DB '$database'\n":
	"Failed to Create DB '$database'\n";

$dbh->disconnect();
exit;
