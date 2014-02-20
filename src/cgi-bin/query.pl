#!/usr/bin/perl

use CGI;
use DBI;
use CGI::Carp qw(fatalsToBrowser);

# defines the input from the HTML form::
my $cgi=new CGI;
$q=CGI->new;
my $sequence=$cgi->param("sequence");
my $aalength=$cgi->param("aa-length");

print $q->header;
print "Content-type:text/html \n\n";

#<--- Section of script here prepares the SQL query and formats the results --->

# defines the parameters for SQL database
my $userid="root;"
my $databtype="mysql";
my $host="localhost";
my $userid="root";
my $password="" ;
my $database="camp"

my $dbh=DBI->connect("DBI:$databtype:$database:$host",$userid,$password) or die ("Database not found"); # opens the connection to the database first
my $sth=$dbh->prepare("SELECT * FROM base where length='%aalength' or sequences='sequence'"); # this is the actual sql query   
$sth=execute(); # runs the sql query
if($sth->rows()==0)
{
    print "Your Database Query did not retrieve any results. Please Try Again";
} # empty result return
else
{
 #<- this section formats the return results -> html chunk only
   $Content=qq(
 <html>   
    <head>
        <title> Just another anti-microbial peptide database|Contact Us</title>
        <link href="query.css" rel="stylesheet" type="text/css" />
        <a href="index.html"><div id="banner">
            <h1>Just another AMP database</h1>
        </div></a>
    </head>
    <body>
        <div id="wrapper" >
            <div 
            <div id="nav-bar">
                <ul>
                    <li><a href="index.html">Home</a></li>
                     <li><a href="about.html">About AMPs</a></li>                    
                    <li><a href="searchdb.html">Search database</a></li>
                    <li><a href="blast.html">BLAST</a></li>
                    <li><a href="resources.html">Other Resources</a></li>
                    <li><a href="contact.html">Contact Us</a></li>
                </ul>
            </div>
            <div id="main-body">
                <h1>Search results</h1>
   <table width="853" border="1" cellspacing="0" cellpadding="0">
   <tr bgcolor="#dddddd">
   <td width="70">ID</td>
   <td width="140">Species</td>
   <td width="70">Length</td>
   <td width="70">Sequence</td>
   <td width="140">Activity</td>
   <td width="140">Database</td>

   </tr>

);
print $Content;
  while (@results=$sth->fetchrow_array())
  {

     print "<tr>\n";
     print "<td>".$results[1]."</td>\n";
     print "<td>".$results[2]."</td>\n";
     print "<td>".$results[3]."</td>\n";
     print "<td>".$results[4]."</td>\n";
     print "<td>".$results[5]."</td>\n";
     print "<td>".$results[6]."</td>\n";
     
     print "</tr>\n";
  } 

  print "</table>\n\n"; # closes the table
} # closes valid results


print "\n</div>\n </div>\n </body>\n </html>" # closes divs main-body, wrapper, body and html tag
# close the connection to SQL DB and exit run of CGI script
$sth->finsh();
$dbh->disconnect();
exit;
