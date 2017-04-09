#!/usr/bin/perl 
# Nathalie Tate 
# This code is freely available to be modified or distributed under the 
# IT License. See LICENSE.txt 


use DBI; 
my @globalistGlobalList;

print("Password for SQL user 'root':");
$pw = <>;
$pw = trim($pw);

my $dbh = DBI->connect("dbi:mysql:", "root","$pw"
	, {PrintError => 0,
	RaiseError => 0}
	);

sub importDB
{
	my $file = shift;

	if ($file =~ /(.+)\.sql/)
	{
		$database = $1;
		$dbh->do("create database $database;") or die("Database already exists...");
		system("sudo mysql $database < $file");
	}

	else
	{
		die;
	}
}

sub trim 
{
	$s = shift; 
	$s =~ s/^\s+|\s+$//g; 
		return $s 
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

sub selectAllWhere
{
	my $table = shift;
	my $col = shift;
	my $var = shift;
	my $val = shift;

	my $statement = "SELECT $col FROM $table where $var = \"$val\"";
	my $preparedStatement  = $dbh->prepare($statement);
	$preparedStatement->execute();

	my @tmp;

	while (@row = $preparedStatement->fetchrow_array())
	{
		push @tmp, $row[0];
	}
	return @tmp;
}

#main

print("Would you like to 1) use an existing database, or 2) import a database
from a .sql file? 
\nNote that importing from .sql files requires root access and a Unix-like
system. For unprivileged accounts on Linux systems, see §2.2.1 in the README.
For Windows systems, see §2.1.2 in the README.
\nAlso note that after importing once, you should chose to select an existing
database for subsequent queries.
\n");

$choice = <>;

if($choice == 2)
{
	print("Enter the name of the file to import. Leave blank to use the default
(CSE345nrt.sql): ");
	my $file = <>;
	$file = $file==""?"CSE345nrt.sql":$file;
	importDB($file);
}

elsif($choice == 1)
{
	print("Enter the name of the database to use. Leave blank to use the default
(CSE345nrt): ");
	$database = <>; 
	$database = $database==""?"CSE345nrt":$database
} 

else
{
	die("Invalid choice...");
}


$dbh->do("use $database;")or die("Database $_ does not exist...");
print("Enter your customer ID: ");
$ID = <>;

print("Customer Information:\n");
print("ID: $ID\n");

$name = selectWhere("Customer","fName","customerID",$ID);
$name = $name." ".selectWhere("Customer","initial","customerID",$ID);
$name = $name." ".selectWhere("Customer","lName","customerID",$ID);
print("Name: $name\n");

$address = selectWhere("Customer","addrLine1","customerID",$ID);
$address = $address." / ".selectWhere("Customer","city","customerID",$ID);
$address = $address.", ".selectWhere("Customer","state","customerID",$ID);
$address = $address." ".selectWhere("Customer","zip","customerID",$ID);
print("Address: $address\n");

print("-------------------------------------------------------\n");
print("\nInvoices:\n");

@accountNum = selectAllWhere("Invoice","accountNum","customerID",$ID);

@pkgID = selectAllWhere("Invoice","pkgID","customerID",$ID);

@date = selectAllWhere("Invoice","date","customerID",$ID);

@due = selectAllWhere("Invoice","amntDue","customerID",$ID);

@paid = selectAllWhere("Invoice","payment","customerID",$ID);

@type = selectAllWhere("Invoice","creditOrShipping","customerID",$ID);

for my $j(0..@accountNum-1)
{
	print("Account #: $accountNum[$j]\n");
	print("Account Type: $type[$j]\n");
	print("Package ID: $pkgID[$j]\n");
	print("Date: $date[$j]\n");
	print("Amount Due: $due[$j]\n");
	print("Amount Paid: $paid[$j]\n");
	print("-------------------------------------------------------\n");
}

print("\nPackage Tracking:\n");

for $i(@pkgID)
{
	print("Package ID: $i\n");
	$date = selectWhere("Tracking","date","pkgID",$i);
	print("Date: $date\n");

	$location = selectWhere("Tracking","currentCity","pkgID",$i);
	$location = $location.", ".selectWhere("Tracking","currentState","pkgID",$i); 

	print("Current Location: $location\n");
	$eta = selectWhere("Tracking","timeToArrival","pkgID","$i");
	print("Time to Arrival: $eta\n");
	print("-------------------------------------------------------\n");

}

$dbh->disconnect();
exit;
