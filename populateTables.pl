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

print("Loading Lists...\n");

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
	return trim($firstNames[int(rand(@firstNames))]);
}
sub randomLastName
{
	return trim($lastNames[int(rand(@lastNames))]); 
}
sub randomMI
{
	return $middleInitials[int(rand(27))];
}
sub randomAddress
{
	$num = $addresses[int(rand(@addresses))];
	$street = trim($nouns[int(rand(@nouns))]);
	$city = trim($nouns[int(rand(@nouns))]);
	$streetSuffix = $stSuffix[int(rand(6))];
	$citySuffix = $citySuffix[int(rand(8))];
	$zip = $zips[int(rand(@zips))];
	$state = trim($states[int(rand(50))]);

	my $tmp = "$num $street $streetSuffix / ";
		$tmp = $tmp.trim("$city $citySuffix"); 
		$tmp = $tmp.", $state $zip";
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

	my $statement = "SELECT $var FROM $table order by rand() limit 1";
	my $preparedStatement  = $dbh->prepare($statement);
	$preparedStatement->execute();

	my @tmp = $preparedStatement->fetchrow_array();
	return $tmp[0];
}

#returns A or B at the given ratio
sub weightedAB
{
	my $A = shift;
	my $B = shift;

	my $Anum = shift;
	my $Bnum = shift;

	my @AB;

	while($Anum > 0)
	{
		push @AB,$A;
		$Anum--;
	}
	while($Bnum > 0)
	{
		push @AB,$B;
		$Bnum--;
	}
	return $AB[int(rand(@AB))];
}

sub dueDate
{
	($_,$_,$_,my $day,my $month,my $year,@_) = localtime(time);
	$month = $monthLookUp[$month];
	$year += 1900;
	if ($month > 12)
	{
		$year++;
		$month -= 12;
	}

	$day = $day>28?28:$day;

	return $year.'-'.$month.'-'.$day;

}

#TODO
sub timeToArrival
{
	return "2 days";
}

print("Done\n");
print("Populating...\n");

## "main" 
$dbh->do("use $database;");

#populate non-fk attributes in Customer
print("  Customer...\n");
for (0..100)
{
	my $fName = randomFirstName;
	my $mi = trim(randomMI);
	my $lName = randomLastName;
	my $address = randomAddress;

	$dbh->do("insert into Customer(fName, initial, lName, address) values (
		'$fName','$mi','$lName','$address');");
}
print("  Done");

#populate non-fk attributes in Package
#and customerID
print("\n  Package...\n");
for (0..200)
{
	my $selectRandom = selectRandom("Customer","customerID");
	my $weightedAB = weightedAB(1,0,5,9);
	my $randomAddress = randomAddress;

	$dbh->do("insert into Package(customerID, hazardous, destination) values
			($selectRandom,$weightedAB,'$randomAddress');");
}
print("  Done\n");

#populate attributes in Tracking
print("  Tracking...\n");
for (0..150)
{
	my $selectRandom = selectRandom("Package","pkgID");
	my $timeToArrival = timeToArrival;
	my $randomAddress = randomAddress;

	$dbh->do("insert into Tracking(date, pkgID, timeToArrival, currentLocation) 
		values(now(),'$selectRandom', '$timeToArrival', '$randomAddress');");
}
print("  Done\n");

#populate Invoice
print("  Invoice...\n");
for (0..200)
{
	my $due = int(rand(10000));
	my $paid = int(rand($due));
	my $randAccountNumber = randAccountNumber;
	my $selectRandom = selectRandom("Customer","customerID");
	my $dueDate = dueDate;
	my $weightedAB = weightedAB("credit",'shipping account',1,1);

	$dbh->do("insert into Invoice(accountNum, customerID, amntDue, payment, date, 
		dueDate, creditOrShipping) values('$randAccountNumber','$selectRandom',$due,$paid, now(),
		'$dueDate','$weightedAB');");
}
print("  Done\n");


print("Done\n");
$dbh->disconnect();
exit;
