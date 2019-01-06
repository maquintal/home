package Logs;

our $VERSION = '1.00';

require Exporter; 

our @ISA = qw(Exporter); 

our %EXPORT_TAGS = ( 'all' => [ qw(
          LOG_Info
		  LOG_Detailed
) ] ); 

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
          LOG_Info
		  LOG_Detailed
);

use Log::Log4perl;
 
   # Configuration in a string ...   [%r] %F %L %m%n
my $conf = q(
  log4perl.category.Foo.Bar          = INFO, Logfile, Screen
 
  log4perl.appender.Logfile          = Log::Log4perl::Appender::File
  log4perl.appender.Logfile.filename = test.log
  log4perl.appender.Logfile.layout   = Log::Log4perl::Layout::PatternLayout
  log4perl.appender.Logfile.layout.ConversionPattern = %m
 
  log4perl.appender.Screen         = Log::Log4perl::Appender::Screen
  log4perl.appender.Screen.stderr  = 0
  log4perl.appender.Screen.layout = Log::Log4perl::Layout::SimpleLayout
  
  log4perl.logger.Debug                                    = INFO, DebugLog
  log4perl.appender.DebugLog                               = Log::Dispatch::FileRotate
  log4perl.appender.DebugLog.size                          = 20M
  log4perl.appender.DebugLog.max                           = 20
  log4perl.appender.DebugLog.filename                      = _DETAILEDLOGFILE_
  log4perl.appender.DebugLog.layout                        = Log::Log4perl::Layout::PatternLayout
  log4perl.appender.DebugLog.layout.ConversionPattern      = %d | %m %n
  log4perl.appender.DebugLog.mode                          = append
  
);
 
   # ... passed as a reference to init()
Log::Log4perl::init( \$conf );

sub LOG_Detailed {

#---------------------------------------------------------------------
#
# Description:
#
#   Write a string in the DETAILED log.
#
# Return value:
#
#   $_[0] : string = message to output in the DETAILED log
#
# Return value:
#
#   None
#
# Example:
#
#   LOG_Detailed("DeleteLunNoMap: NO LUN to remove!");
#
#---------------------------------------------------------------------
#
    my $string = $_[0];
	my $LOG_LEVEL = "DETAILED";

    if ( $LOG_LEVEL eq "DETAILED" ) {
        Log::Log4perl::get_logger("Detailed")->info($string);
   } elsif ( $LOG_LEVEL eq "DEBUG" ) {
        Log::Log4perl::get_logger("Detailed")->info($string);
        Log::Log4perl::get_logger("Debug")->info($string);
   }

    if ( ($LOG_SCREEN eq "DETAILED") or
         ($LOG_SCREEN eq "DEBUG") ) {
        Log::Log4perl::get_logger("Screen")->info($string);
    }
}