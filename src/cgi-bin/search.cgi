#!/usr/bin/perl
use warnings;
use DBI;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

my $cgi= new CGI;
my $q = CGI->new;


# define the search key here
my $id=$cgi->param("id"); # gets activity from form
# no need to change this
my $userid = "visitor";
my $password= "";
my $database = "jamp";
my $databtype = "mysql";


my $dbh = DBI->connect("DBI:$databtype:$database",$userid,$password) or die("can't connect !");

my $sth=$dbh->prepare("SELECT * FROM AMPs WHERE NR= $id; ");
$sth->execute();

print $q->header;
# define some html elements here first
print "<html>";
print "<head>";
print "<title>Just Another anti-microbial peptide database|".$id."</title>";
my $Content=qq(
<link href="http://bioslax11.bic.nus.edu.sg/CSS/query.css" rel="stylesheet" type="text/css" />
<a href="index.html"><div id="banner">\n<h1>Just another AMP database</h1>\n</div></a>
</head>
<body>
<div id="wrapper" >
<div id="nav-bar">
<ul>
<li><a href="http://bioslax11.bic.nus.edu.sg/index.html">Home</a></li>
<li><a href="http://bioslax11.bic.nus.edu.sg/about.html">About AMPs</a></li>
<li><a href="http://bioslax11.bic.nus.edu.sg/searchdb.html">Search database</a></li>
<li><a href="http://bioslax11.bic.nus.edu.sg/blast.html">BLAST</a></li>
<li><a href="http://bioslax11.bic.nus.edu.sg/resources.html">Other Resources</a></li>
<li><a href="http://bioslax11.bic.nus.edu.sg/contact.html">Contact Us</a></li>\n</ul>
</div>
<div id="main-body">
);
print $Content;

print "<h1>$id</h1>";

my $Content=qq(
<div id="tableenv">
<table width="853" border="1" cellspacing="0" cellpadding="0">
);

print $Content;
my @results= ();

     print "<tr>\n";
     print "<td>NR ID</td>";
     print "<td>".$results[1]."</td></tr>";
     print "<tr>\n";
     print "<td>Assigned Name</td>";
     print "<td>".$results[3]."</td></tr>\n";
     print "<tr>\n";
     print "<td>UniProt ID</td>\n";
     print "<td>".$results[8]."</td></tr>\n";
     print "<tr>\n";
     print "<td> Species of origin</td>\n";
     print "<td>".$results[4]."</td></tr>\n";
print "</table></div>"; # closes the table

$sth->finish();
$dbh->disconnect();

print "</div></div></body></html>"; # closes the body and html tags
exit;
