#!/usr/bin/perl
use warnings;
use strict;
use DBI;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

my $cgi= new CGI;
my $q = CGI->new;


# define the search key here
my $activity=$cgi->param("activity"); # gets activity from form
my $source=$cgi->param("database"); # gets database selection from form
my $aalength=$cgi->param("length"); # gets the length selection from form
my $count=0;

# no need to change this
my $userid = "visitor";
my $password= "";
my $database = "jamp";
my $databtype = "mysql";


my $dbh = DBI->connect("DBI:$databtype:$database",$userid,$password) or die("can't connect !");

my $sth=$dbh->prepare("SELECT * FROM AMPs WHERE SequenceLength<=$aalength  AND Activity LIKE ('%$activity%') ORDER BY NR ASC; ");
$sth->execute();


print $q->header;
# define some html elements here first
# Print out the HTML output if any
my $counts=$sth->rows();
my $Content=qq(
<html>
<head>
<title>Just another anti-microbial peptide database|Search Results</title>\n
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
<div id="parameters">
<p>Your search returned <b><font color="red">$counts</font></b> results. Click <a href="http://bioslax11.bic.nus.edu.sg/searchdb.html"><font><b> HERE</b></font></a> to search again</p>
</div>
);
print $Content;

my $Content=qq(
<div id="tableenv">
<table width="853" border="1" cellspacing="0" cellpadding="0">
<th width="70" bgcolor="#F4FA58"> NR</th>
<th width="70" bgcolor="#F4FA58">ID</th>
<th width="140" bgcolor="#F4FA58">Species</th>
<th width="70" bgcolor="#F4FA58">Length</th>
<th width="140" bgcolor="#F4FA58">Activity</th>
<th width="140" bgcolor="#F4FA58">PubMed</th>
<th width="140" bgcolor="#F4FA58">UniProt</th>
    <th width="140" bgcolor="#F4FA58">Sequence</th>);

print $Content;
my @results= ();
while (@results=$sth->fetchrow_array()){

     print "<tr>\n";
     print "<td align=center><a href=search.cgi?id=$results[1]>".$results[1]."</a></td>";
     print "<td align=center><a href=$results[11]>".$results[2]."</a></td>\n";
     print "<td align=center><i>".$results[4]."</i></td>\n";
     print "<td align=center>".$results[6]."</td>\n";
     #print "<td>".$results[8]."</td>\n";
     my $folded=$results[7];
     $folded=~ s/,/<br>/sg;
     print "<td align=center>".$folded."</td>\n";
print "<td align=center><a href=http://www.ncbi.nlm.nih.gov/pubmed/$results[9] target=blank>".$results[9]."<ga></td>";
    my $short=$results[8];
    $short=~ s/,/<br>/sg;
     print "<td align=center><a href=http://www.uniprot.org/uniprot/$results[8] target=blank>".$short."</a></td>";
     my $seq=$results[5];
     $seq=~ s/(.{20})/$1<br>/g;
     print "<td align=center><pre>".$seq."</pre></td>\n";
     print "</tr>\n";
  } 

print "</table></div>"; # closes the table

$sth->finish();
$dbh->disconnect();

print "</div></div></body></html>"; # closes the body and html tags
exit;
