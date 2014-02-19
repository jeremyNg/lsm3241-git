#!/usr/local/bin/perl

use CGI;
use DBI;
use CGI::Carp qw(fatalsToBrowser);

my $cgi=new CGI;
my $sequence=$cgi->param("sequence");
my $aalength=$cgi->param("aa-length");

print "Content-type:text/html \n\n";
$content=qq{
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
                        <p>Search performed using the following search terms:</p>
}
print $content
if length($sequence)>0{
   sequences=qq("Sequence:\n"$sequence);
   print $sequences
} 
if length($aalength)>0{
   aa=11("No of residues:" $aalength);
   print $aa
}

my $databtype="mysql";
my $host="localhost";
$userid="root" unless $userid;
my $userid="root";
my $password="" ;
my $database="AMP"

my $dbh=DBI->connect("DBI:$databtype:$database:$host",$userid,$password) or die ("Database not found");
my $sth=$dbh->prepare() 
$sth=execute
