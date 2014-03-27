#!/usr/bin/perl
use strict;
use DBI;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

my $cgi= new CGI;
my $q = CGI->new;

print $q->header;
# define some html elements here first
my $Content=qq(<html>\n<head>\n<title>Just another anti-microbial peptide database|Search Results</title>\n<link href="http://bioslax11.bic.nus.edu.sg/CSS/query.css" rel="stylesheet" type="text/css" />\n<a href="index.html"><div id="banner">\n<h1>Just another AMP database</h1>\n</div></a>\n</head>\n<body>\n<div id="wrapper" >\n<div id="nav-bar">\n<ul>\n<li><a href="index.html">Home</a></li>\n<li><a href="about.html">About AMPs</a></li>\n<li><a href="searchdb.html">Search database</a></li>\n<li><a href="blast.html">BLAST</a></li>\n<li><a href="resources.html">Other Resources</a></li>\n<li><a href="contact.html">Contact Us</a></li>\n</ul>\n</div>\n<div id="main-body">\n<h1>Search results</h1>);
print $Content;

# define the search key here
my $activity=$cgi->param("activity"); # gets activity from form
my $source=$cgi->param("database"); # gets database selection from form
my $aalength=$cgi->param("length"); # gets the length selection from form
my $search= '("'. $source .'")';
# no need to change this
my $userid = "visitor";
my $password= "";
my $database = "camp";
my $databtype = "mysql";
my $dbh = DBI->connect("DBI:$databtype:$database",$userid,$password) or die("can't connect !");
my $sth = $dbh->prepare ("SELECT * FROM base WHERE length <= $aalength AND source IN $search"); # this prepares the statement
$sth-> execute(); # this executes the sql search

# Print out the HTML output if any
my $counts=$sth->rows();
my $counts=$counts+1; #adds 1 to the count

my $Content=qq(<table width="853" border="1" cellspacing="0" cellpadding="0">\n<th width="70">ID</th>\n<th width="140">Species</th>\n<th width="70">Length</th>\n\n<th width="140">Activity</th>\n<th width="140">Database</th>\n);
print $Content;
my @results= ();
while (@results=$sth->fetchrow_array()){

     print "<tr>\n";
     print "<td>".$results[1]."</td>\n";
     print "<td>".$results[2]."</td>\n";
     print "<td>".$results[3]."</td>\n";
     #print "<td>".$results[4]."</td>\n";
     print "<td>".$results[5]."</td>\n";
     print "<td>".$results[6]."</td>\n";
     
     print "</tr>\n";
  } 

print "</table>\n\n"; # closes the table

$sth->finish();
$dbh->disconnect();

print "</body>\n</html>"; # closes the body and html tags
exit;
