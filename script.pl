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

#use Log::Log4perl;
#use Log::Dispatch::FileRotate;

#--------------------------------------
# Enable logging
#--------------------------------------
LOG_EnableLogger("DEBUG");

#--------------------------------------
# Set_LogFilename
#--------------------------------------
LOG_SetLogFilename("REPORT", "${MY_SCRIPTNAME}_REPORT_${MY_PID}.log");

#--------------------------------------
# GLOBAL VAR
#--------------------------------------
my $cmd_status;

#--------------------------------------
# MAIN
#--------------------------------------

LOG_Report_Summary("hello");