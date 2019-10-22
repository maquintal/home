package Global;

#--------------------------------------
# Import CPAN modules
#--------------------------------------
use Cwd;
use File::Basename;
use Sys::Hostname;
use Cwd 'abs_path';

our $VERSION = '1.00';

require Exporter; 

our @ISA = qw(Exporter); 

our %EXPORT_TAGS = ( 'all' => [ qw(
		$SUCCESS
		$FAILED
		$ERROR
		$WARNING
		$SUSPEND
		$TRUE
		$FALSE
		$UNDEFINED
		$MY_PID
		$MY_PROGRAM
		$MY_SCRIPTNAME
		$WORKING_DIR
		$LOG_DIR
) ] ); 

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
		$SUCCESS
		$FAILED
		$ERROR
		$WARNING
		$SUSPEND
		$TRUE
		$FALSE
		$UNDEFINED
		$MY_PID
		$MY_PROGRAM
		$MY_SCRIPTNAME
		$WORKING_DIR
		$LOG_DIR
);

#-------------------------------------------------------
# Status values
#-------------------------------------------------------
$SUCCESS = 1;
$FAILED = 0;
$ERROR = -1;
$WARNING = 2;
$SUSPEND = 3;
$TRUE = 1;
$FALSE = 0;
$UNDEFINED = -1;

#--------------------------------------
# Script information
#--------------------------------------
$MY_PID = $$;
($MY_SCRIPTNAME = basename($0)) =~ s/\.[^.]+$//;
$MY_PROGRAM = $MY_SCRIPTNAME;
$MY_SCRIPTNAME =~ s/_//g; # remove all underscore from $MY_SCRIPTNAME
$WORKING_DIR = dirname(abs_path($0));

#--------------------------------------
# Directories
#--------------------------------------
$LOG_DIR     = "$WORKING_DIR/Logs";
 
1;