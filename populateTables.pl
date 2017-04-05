#!/usr/bin/perl 
# Nathalie Tate This code is freely available to be modified or distributed under the MIT License. See LICENSE.txt This file MUST be run after createTables.pl 

use DBI; 
use Math::Random;
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
@zips = ('11111'..'99999');
@addresses = ('1'..'999999');
@stSuffix = ("St", "Ave", "Ln", "Ct", "Blvd", "Rd");
@citySuffix = ("City", "Town", "Village", "Township", "Municipality", 
	"Borough", "Parish","");
@states = <STATES>;
%domesticShippingRate = ("overnight" => 25, "express" => 15, "standard" => 5);
%extraFees = ("" => 0, "hazmat" => 100, "oversize" => 25, "international" => 10);
@couriers = ("plane","truck","warehouse","bicycle courier");

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
	my $a = random_uniform_integer($_,1000,9999);
	my $b = random_uniform_integer($_,1000,9999);
	return "$a$b";
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
sub selectWhere
{
	my $table = shift;
	my $col = shift;
	my $var = shift;
	my $val = shift;

	my $statement = "SELECT $col FROM $table where $var = \"$val\"";
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
	$year += 1900;
	$month += 6;
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

	$dbh->do("insert into Customer(fName, initial, lName, address) 
		values ('$fName','$mi','$lName',\"$address\");");
}
print("  Done");

#populate non-fk attributes in Package
#and customerID
print("\n  Package...\n");
for (0..200)
{
	my $selectRandom = selectRandom("Customer","customerID");
	my $hazmat = weightedAB(1,0,1,9);
	my $randomAddress = randomAddress;
	my $randomAddress0 = randomAddress;
	my $weight = int(rand(1000));

	my @shipping = ("express", "standard"); 

	#TODO this needs to be 1) fixe and 2) updated when issue #2/#3 are fixed
	if($randomAddress =~ /^\S+\s\S+\s\S+ \/ \S+(\s\S+), (AK|AZ|AR|CA|CO|CT|DE|FL|GA|ID|IL|IN|IA|KS|KY|LA|ME|MT|NE|NV|NH|NJ|NM|NY|NC|ND|OH|OK|OR|MD|MA|MI|MN|MS|MO|PA|RI|SC|SD|TN|TX|UT|VT|VA|WA|WV|WI|WY) \S+/)
	{
		my @shipping = ("overnight", "express", "standard");
	}

	my $shipping1 = $shipping[int(rand(@shipping))];
	#DEBUG
	#print "$shipping1\n";

	$dbh->do("insert into Package(customerID, hazardous, weight, shipping,
		source, destination) values ($selectRandom,$hazmat,$weight,\"$shipping1\",
		\"$randomAddress0\",\"$randomAddress\");");
}
print("  Done\n");

#populate attributes in Tracking
print("  Tracking...\n");
for $i(0..200)
{
	my $timeToArrival = timeToArrival;
	my $randomAddress = randomAddress;
	my $courierID = $couriers[int(rand(@couriers))];
	$courierID = "$courierID"." # ".int(rand(1000));

	$dbh->do("insert into Tracking(date, pkgID, timeToArrival, courierID,
		currentLocation)values(now(),'$i', '$timeToArrival','$courierID',
		'$randomAddress');");
}
print("  Done\n");

#populate CustomsManifest
print("  CustomsManifest...\n");
for $i (0..200)
{
	if (!(selectWhere("Package","destination","pkgID",$i) =~ /^\S+\s\S+\s\S+ \/ \S+(\s\S+), (AK|AZ|AR|CA|CO|CT|DE|FL|GA|ID|IL|IN|IA|KS|KY|LA|ME|MT|NE|NV|NH|NJ|NM|NY|NC|ND|OH|OK|OR|MD|MA|MI|MN|MS|MO|PA|RI|SC|SD|TN|TX|UT|VT|VA|WA|WV|WI|WY|HI|AL) \S+/))
	{
		my $contents = trim($nouns[int(rand(@nouns))]);
		my $value = int(rand(100000));

		$dbh->do("insert into CustomsManifest(contents,value) values(\"$contents\",
			$value);"); 
		my $customsID = selectWhere('CustomsManifest','customsID','contents',$contents);
		$dbh->do("update Package set customsID = $customsID where pkgID = $i;"); 
	}
}
print("  Done\n"); 

#populate Invoice
print("  Invoice...\n");
for $i(0..200)
{
	my $shipping = selectWhere('Package','shipping','pkgID',$i);
	my $international = selectWhere('Package','customsID','pkgID',$i);

	my $oversize = selectWhere('Package','weight','pkgID',$i);
	$oversize = 100 < $oversize?"oversize":"";

	my $hazmat = selectWhere('Package','hazardous','pkgID',$i);
	$hazmat = defined $hazmat && $hazmat > 0? "hazmat" : "";

	$international = defined $international?"international":"";
	$oversize = $oversize>0?"oversize":"";
	$hazmat = $hazmat!=0?"hazmat":"";

	my $due = $domesticShippingRate{$shipping} + $extraFees{$international} +
		$extraFees{$oversize} + $extraFees{$hazmat};

	my $paid = int(rand($due));
	my $randAccountNumber = randAccountNumber;
	my $selectRandom = selectRandom("Customer","customerID");
	my $dueDate = dueDate;
	my $weightedAB = weightedAB("credit",'shipping account',1,1);

	$dbh->do("insert into Invoice(pkgID, accountNum, customerID, amntDue,
		payment, date, dueDate, creditOrShipping)
		values($i,$randAccountNumber,$selectRandom,$due,
		$paid,now(),\"$dueDate\",\"$weightedAB\");");
}
print("  Done\n");

print("Done\n");
$dbh->disconnect();
exit;
