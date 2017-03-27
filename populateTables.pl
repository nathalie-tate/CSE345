#!/usr/bin/perl
# Nathalie Tate
# This code is freely available to be modified or distributed under the MIT 
#	License. See LICENSE.txt
#
# This file MUST be run after createTables.pl

use DBI;

$database='MooCow';

my $dbh = DBI->connect("dbi:mysql:", "root",""
## debug
#, {PrintError => 0,
#RaiseError => 0}
	);

### populate the tables

print("Loading Lists...");

open FIRSTNAME,"<","data/firstNames.csv" or die;
open LASTNAME, "<","data/lastNames.csv"  or die;
open NOUNLIST, "<","data/nounlist.csv"	 or die;
open STATES, 	 "<","data/states.csv"		 or die;

@firstNames = <FIRSTNAME>;
@lastNames  = <LASTNAME>;
@nouns			= <NOUNLIST>;
@middleInitials = ('A'..'Z',' ');
@accounts = ('00000'..'99999');
@zips = ('11111'..'99999');
@addresses = ('1'..'999999');
@stSuffix = ("St", "Ave", "Ln", "Ct", "Blvd", "Rd");
@citySuffix = ("City", "Town", "Village", "Township", "Municipality", 
		"Borough", "Parish","");
@states = <STATES>;

close FIRSTNAME;
close LASTNAME;
close NOUNLIST;
close STATES;

sub trim 
{
	$s = shift; 
	$s =~ s/^\s+|\s+$//g; 
	return $s 
};

sub randomFirstName
{
	return '"'.trim($firstNames[int(rand(@firstNames))]).'"';
}
sub randomLastName
{
	return '"'.trim($lastNames[int(rand(@lastNames))]).'"'; 
}
sub randomMI
{
	return '"'.$middleInitials[int(rand(27))].'"';
}
sub randomAddress
{
	$num = $addresses[int(rand(@addresses))];
	$street = trim($nouns[int(rand(@nouns))]);
	$streetSuffix = $stSuffix[int(rand(6))];
	$citySuffix = $citySuffix[int(rand(8))];
	$zip = $zips[int(rand(@zips))];
	$state = $states[int(rand(50))];
	$city = trim($nouns[int(rand(@nouns))]);

	my $tmp = '"'.$num.' '.$street.' '.$streetSuffix.', '.$city.' '.$citySuffix.', '.
		$state.' '.$zip.'"';
	return $tmp;
}
sub accountNumber
{
	return $accounts[int(rand(@accounts))].$accounts[int(rand(@accounts))];
}

print("Done\n");
print("Populating...");

## "main" 
$dbh->do("use $database;");
for $i (0..100)
{
	$dbh->do('insert into Customer(fName, initial, lName, address)
			values('.randomFirstName.','.randomMI.','.randomLastName.','.randomAddress
			.');');
}

print("Done\n");
$dbh->disconnect();
exit;
