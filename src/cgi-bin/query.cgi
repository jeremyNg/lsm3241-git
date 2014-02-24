#!/usr/bin/perl

use DBI;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

my $cgi= new CGI;
$q = CGI->new;

my $keyword=$cgi->param("activity");
my $length=$cgi->param("aa-length");
print $q->header;

my $userid = "visitor";
my $password= "";
my $database = "camp";

# no need to change this
my $databtype = "mysql";

# connection to the database
my $dbh = DBI->connect("DBI:$databtype:$database",$userid,$password) or die("can't connect !");

# prepare the SQL statement
#
# NOTE : This is not a good way to specify the variable, you should replace the variable with ?
# However, for simplicity purpose we will just put the variable directly.
# Find out why it is not a good idea to put the variable into the SQL statement.
my $sth = $dbh->prepare ("SELECT * FROM base 
WHERE UPPER(activity) LIKE UPPER('%$keyword%') AND length=$length;") or die("can't prepare SQL");

# execute the SQL statement
$sth-> execute();


# Print out the HTML output if any
$counts=$sth->rows();

if($sth->rows()==0)
{
 $Content = qq(
 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
    <head>
        <title> Just another anti-microbial peptide database|Contact Us</title>
        <link href="http://bioslax11.bic.nus.edu.sg/CSS/query.css" rel="stylesheet" type="text/css" />
        <a href="http://bioslax11.bic.nus.edu.sg/index.html"><div id="banner">
            <h1>Just another AMP database</h1>
        </div></a>
    </head>


<body>
<p>You have entered the search keyword(s): <font color="red">$keyword</font> </p>
<br>

<h2> Your Database Query did not retrieve any results. Please <a href="http://bioslax11.bic.nus.edu.sg/searchdb.html">Try Again</a>
</h2>
);
print $Content;
   
}
else
{
 $Content = qq(
 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
    <head>
        <title> Just another anti-microbial peptide database|Search Results</title>
        <link href="http://bioslax11.bic.nus.edu.sg/CSS/query.css" rel="stylesheet" type="text/css" />
        <a href="http://bioslax11.bic.nus.edu.sg/index.html"><div id="banner">
            <h1>Just another AMP database</h1>
        </div></a>
    </head>


<body>
<p>You have entered the search keyword(s): <font color="red">$keyword</font> </p>

<p>Your database query retrieved the following <font color="red">$counts</font> result(s):</p>

 <table width="853" border="1" cellspacing="0" cellpadding="0">
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

  print "</table>\n\n";

}

print "\n</body>\n</html>";

# disconnect from MYSQL database and close the connection properly
$sth->finish();
$dbh->disconnect();

exit;
