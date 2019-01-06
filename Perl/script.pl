#!/usr/bin/perl
use strict;
use warnings;

use Cwd qw(abs_path);
use File::Basename;

#--------------------------------------
# Import local libraries
#--------------------------------------

sub get_lib {
    my $libdir = dirname(abs_path($0))."/Lib";
    return ($libdir);
} 

use lib get_lib();

use Global;
use Logs;
use Functions;

#--------------------------------------
# Import CPAN modules
#--------------------------------------

#use Time::Local;
#use DBI;

use Log::Log4perl;
#use Log::Dispatch::FileRotate;

#--------------------------------------
# GLOBAL VAR
#--------------------------------------
my $cmd_status;

#--------------------------------------
# MAIN
#--------------------------------------
my @add_res = ();
 ($cmd_status, @add_res) = add("5","6");
 
 if ( $cmd_status == $SUCCESS ) {
	print "$cmd_status, @add_res\n";
 }


# 
#my $dbfile = "sample.db";
# 
#my $dsn      = "dbi:SQLite:dbname=$dbfile";
#my $user     = "";
#my $password = "";
#my $dbh = DBI->connect($dsn, $user, $password, {
#   PrintError       => 0,
#   RaiseError       => 1,
#   AutoCommit       => 1,
#   FetchHashKeyName => 'NAME_lc',
#});
# 
# ...
# 
LOG_Detailed("onr,two,testing");
#
#$dbh->disconnect;