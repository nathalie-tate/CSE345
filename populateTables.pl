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
%monthLookUp = ('Jan' => 1,
								'Feb' => 2,
								'Mar' => 3,
								'Apr' => 4,
								'May' => 5,
								'Jun' => 6,
								'Jul' => 7,
								'Aug' => 8,
								'Sep' => 9,
								'Oct' => 10,
								'Nov' => 11,
								'Dec' => 12);

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

	my $tmp = '"'.$num.' '.$street.' '.$streetSuffix.', '.$city.' '.$citySuffix.
		', '.$state.' '.$zip.'"';
	return $tmp;
}
sub randAccountNumber
{
	return $accounts[int(rand(@accounts))].$accounts[int(rand(@accounts))];
}

#subroutine for selecting random element from column. 
sub selectRandom
{
	my $table = shift;
	my $var = shift;

	my $statement = "SELECT ".$var." FROM ".$table;
	my $preparedStatement  = $dbh->prepare($statement);
	$preparedStatement->execute();

	while (my @row = $preparedStatement->fetchrow_array())
	{
		push my @contents $row[0];
	}

	return $contents[int(rand(@contents))]; 
}

#returns A or B at the given ratio
sub weightedAB
{
	my $A = shift;
	my $B = shift;

	my $Anum = shift;
	my $Bnum = shift;

	while($Anum > 0)
	{
		push my @AB $A;
	}
	while($Bnum > 0)
	{
		push my @AB $B;
	}
	return $AB[int(rand(@AB))];
}

sub dueDate
{
	my ($_,$_,$_,$day,$month,$yr19,@_) = localtime(time);
	$month = $monthLookUp[$month];
	$year += 1900;
	if ($month > 12)
	{
		$year++;
		$month -= 12;
	}

	$day = $day>28?28:$day;

	return $year.'-'.$month.'-'$day;

}

#TODO
sub timeToArrival
{
	return "2 days";
}

print("Done\n");
print("Populating...");

## "main" 
$dbh->do("use $database;");

#populate non-fk attributes in Customer
for (0..100)
{
	$dbh->do('insert into Customer(fName, initial, lName, address)
		values('.randomFirstName.','.randomMI.','.randomLastName.','.randomAddress
		.');');
}

#populate non-fk attributes in Package
#and customerID
for (0..200)
{
	$dbh->do('insert into Package(customerID, hazardous, destination)
		values ('.selectRandom("Customer","customerID").','.weightedAB('yes','no'
		,1,9).','.randomAddress.');');
}

#populate attributes in Tracking
for (0..150)
{
	$dbh->do('insert into Tracking(date, pkgID, timeToArrival, currentLocation) 
		values(now(),'.selectRandom(Package, pkgID).','
		.timeToArrival.','
		.randomAddress ### TODO ### change to just city/state/country
		.');');
}

#populate Invoice
for (0..200)
{
	my $due = int(rand(10000));
	my $paid = int(rand($due));
	$dbh->do('insert into Invoice(accountNum, amntDue, payment, date, dueDate,
		creditOrShipping) values ('.randAccountNumber.','.$due.','.$paid.', now(),
		'.dueDate.','.weightedAB('credit','shipping',1,1).');');
}


print("Done\n");
$dbh->disconnect();
exit;
