#!/usr/bin/perl
use warnings;
use DBI;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

my $cgi= new CGI;
my $q = CGI->new;


# define the search key here
my $sequence=$cgi->param("sequence");

 # to tidy up the input sequence
$sequence2= chomp($sequence);
$sequence2=~ s/^\s*$//sg;

#preformt the statement for the blast query
my $statement="echo -e $sequence|blastall -p blastp -d new.fasta -m 8";

# html header
print $q->header;
my $Content=qq(
<html>
<head>
<title>Just another anti-microbial peptide database|BLAST Results</title>\n
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
print "<h2> BLAST result(s)</h2>\n";


# formatting the html table
my @y=`$statement`; # runs and stores the data as an array @y, which we will use a foreach, split at each foreach, and then pass the values into the various slots

foreach (@y){
	my @t=split('\t',$_);
print "<div style=padding-left: \"40px\"; padding-top: \"40px\">\n<table width=\"900px\" cellspacing=\"0\" cellpadding=\"1\"  style=\"table-layout:fixed;border-bottom-color:\#E6E6E6; border-bottom: solid\" >";
print "<tr width=\"150px\">";
print "<td>Query Sequence</td>";
print "<td style=\"word-wrap: break-word; width:700px; max-width:700px;\">".$statement."</td>\n";
print "<tr width=\"150px\">";
print "<td>Top hit ID</td>";
print "<td><a href=search.cgi?id=$l>".$t[1]."</a></td>\n";
print "<tr width=\"150px\">";
print "<td>Percentage identity</td>";
print "<td>".$t[2]."</td>\n";
print "<tr width=\"150px\">";
print "<td>Alignment length</td>";
print "<td>".$t[3]."</td>\n";
print "<tr width=\"150px\">";
print "<td>Mismatches</td>";
print "<td>".$t[4]."</td>\n";
print "<tr width=\"150px\">";
print "<td>Gaps</td>";
print "<td>".$t[5]."</td>\n";
print "<tr width=\"150px\">";
print "<td>E-score</td>";
print "<td>".$t[10]."</td>\n";
print "<tr width=\"150px\">";
print "<td>Bit score</td>";
print "<td>".$t[11]."</td>\n";
print "</table><br>";
}

print "Cick <a href=http://bioslax11.bic.nus.edu.sg/blast.html>here</a> to return to BLAST page";
print "</div></div></body></html>\n"; # closes the body and html tags
#system("rm results.o"); # removes the result file
exit;
