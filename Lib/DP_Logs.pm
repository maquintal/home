package DP_Logs;

use Cwd qw(abs_path);
use File::Basename;

#
# Get the local Lib directory which contains
# the Storage libraries
#
sub get_lib {
    my $libdir = dirname(abs_path($0))."/Lib";
    return ($libdir);
}

use lib get_lib();

use Log::Log4perl;
use Log::Dispatch::FileRotate;
use Global;
use Time::Local;

our $VERSION = '1.09'; 

require Exporter;

our @ISA = qw(Exporter);
 
our %EXPORT_TAGS = ( 'all' => [ qw(
          LOG_EnableLogger
          LOG_EnableScreenLogger
          LOG_Summary
          LOG_Operations_Summary
		  LOG_Report_Summary
          LOG_Detailed
          LOG_Debug
          LOG_Report
          LOG_Locks
          LOG_SetLogFilename
          LOG_RenameLogFile
          $DEFAULT_SUMMARY_LOGFILE
          $DEFAULT_DETAILED_LOGFILE
          $DEFAULT_DEBUG_LOGFILE
          $DEFAULT_REPORT_LOGFILE
          $DEFAULT_LOCK_LOGFILE
          $CURRENT_SUMMARY_LOGFILE
          $CURRENT_DETAILED_LOGFILE
          $CURRENT_DEBUG_LOGFILE
          $CURRENT_REPORT_LOGFILE
          $CURRENT_LOCK_LOGFILE
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
          LOG_EnableLogger
          LOG_EnableScreenLogger
          LOG_Summary
          LOG_Operations_Summary
		  LOG_Report_Summary
          LOG_Detailed
          LOG_Debug
          LOG_Report
          LOG_Locks
          LOG_SetLogFilename
          LOG_RenameLogFile
          $DEFAULT_SUMMARY_LOGFILE
          $DEFAULT_DETAILED_LOGFILE
          $DEFAULT_DEBUG_LOGFILE
          $DEFAULT_REPORT_LOGFILE
          $DEFAULT_LOCK_LOGFILE
          $CURRENT_SUMMARY_LOGFILE
          $CURRENT_DETAILED_LOGFILE
          $CURRENT_DEBUG_LOGFILE
          $CURRENT_REPORT_LOGFILE
          $CURRENT_LOCK_LOGFILE
);


#-------------------------------------------------------
# Global variables for LOG functions
#-------------------------------------------------------

my $DETAILED_LOG;
my $SUMMARY_LOG;
my $DEBUG_LOG;
my $REPORT_LOG;
my $LOCK_LOG;
my $LOG_LEVEL = "NONE";
my $LOG_SCREEN = "NONE";

#
# Get current date and time
#
my ($sec,$min,$hour,$mday,$month,$year,$wday) = localtime;
$year = $year+1900;
$month = $month+1;
$month = substr('0'.$month,-2);
 
#$STORAGE_SUMMARY_LOGFILE  = "Storage_Operations_Summary_${year}-${month}.log";
#$STORAGE_LOCKS_LOGFILE    = "Storage_Locks_${year}-${month}.log";
 
#$STORAGE_SUMMARY_LOGFILE  = "Storage_Operations_Summary.log";
#$STORAGE_LOCKS_LOGFILE    = "Storage_Locks.log";
 
$DEFAULT_SUMMARY_LOGFILE  = "${MY_SCRIPTNAME}_SUMMARY.log";
$DEFAULT_DETAILED_LOGFILE = "${MY_SCRIPTNAME}_DETAILED.log";
$DEFAULT_DEBUG_LOGFILE    = "${MY_SCRIPTNAME}_DEBUG.log";
$DEFAULT_REPORT_LOGFILE   = "${MY_SCRIPTNAME}_REPORT.log";
$DEFAULT_LOCK_LOGFILE     = "${MY_SCRIPTNAME}_LOCK.log";
 
$CURRENT_SUMMARY_LOGFILE  = $DEFAULT_SUMMARY_LOGFILE;
$CURRENT_DETAILED_LOGFILE = $DEFAULT_DETAILED_LOGFILE;
$CURRENT_DEBUG_LOGFILE    = $DEFAULT_DEBUG_LOGFILE;
$CURRENT_REPORT_LOGFILE   = $DEFAULT_REPORT_LOGFILE;
$CURRENT_LOCK_LOGFILE     = $DEFAULT_LOCK_LOGFILE;
 
my $LOG_CONFIG = q(
    log4perl.logger.Screen                                   = INFO, ScreenLog
    log4perl.appender.ScreenLog                              = Log::Log4perl::Appender::Screen
    log4perl.appender.ScreenLog.stderr                       = 1
    log4perl.appender.ScreenLog.layout                       = Log::Log4perl::Layout::PatternLayout
    log4perl.appender.ScreenLog.layout.ConversionPattern     = %m %n
	
    log4perl.logger.Summary                                  = INFO, SummaryLog
    log4perl.appender.SummaryLog                             = Log::Dispatch::FileRotate
    log4perl.appender.SummaryLog.size                        = 20M
    log4perl.appender.SummaryLog.max                         = 7
    log4perl.appender.SummaryLog.filename                    = _SUMMARYLOGFILE_
    log4perl.appender.SummaryLog.layout                      = Log::Log4perl::Layout::PatternLayout
    log4perl.appender.SummaryLog.layout.ConversionPattern    = %d | %m %n
    log4perl.appender.SummaryLog.mode                        = append
	
#    log4perl.logger.OpsSummary                               = INFO, OpsSummaryLog
#    log4perl.appender.OpsSummaryLog                          = Log::Log4perl::Appender::File
#    log4perl.appender.OpsSummaryLog.filename                 = _OPSSUMMARYLOGFILE_
#    log4perl.appender.OpsSummaryLog.layout                   = Log::Log4perl::Layout::PatternLayout
#    log4perl.appender.OpsSummaryLog.layout.ConversionPattern = %d | %m %n

    log4perl.logger.Detailed                                 = INFO, DetailedLog
    log4perl.appender.DetailedLog                            = Log::Dispatch::FileRotate
    log4perl.appender.DetailedLog.size                       = 20M
    log4perl.appender.DetailedLog.max                        = 7
    log4perl.appender.DetailedLog.filename                   = _DETAILEDLOGFILE_
    log4perl.appender.DetailedLog.layout                     = Log::Log4perl::Layout::PatternLayout
    log4perl.appender.DetailedLog.layout.ConversionPattern   = %d | %m %n
    log4perl.appender.DetailedLog.mode                       = append
	
    log4perl.logger.Debug                                    = INFO, DebugLog
    log4perl.appender.DebugLog                               = Log::Dispatch::FileRotate
    log4perl.appender.DebugLog.size                          = 20M
    log4perl.appender.DebugLog.max                           = 20
    log4perl.appender.DebugLog.filename                      = _DEBUGLOGFILE_
    log4perl.appender.DebugLog.layout                        = Log::Log4perl::Layout::PatternLayout
    log4perl.appender.DebugLog.layout.ConversionPattern      = %d | %m %n
    log4perl.appender.DebugLog.mode                          = append
	
    log4perl.logger.Report                                   = INFO, ReportLog
    log4perl.appender.ReportLog                              = Log::Log4perl::Appender::File
    log4perl.appender.ReportLog.mode                         = append
    log4perl.appender.ReportLog.filename                     = _REPORTLOGFILE_
    log4perl.appender.ReportLog.layout                       = Log::Log4perl::Layout::PatternLayout
    log4perl.appender.ReportLog.layout.ConversionPattern     = %m %n
	
#    log4perl.logger.Locks                                    = INFO, LocksLog
#    log4perl.appender.LocksLog                               = Log::Dispatch::FileRotate
#    log4perl.appender.LocksLog.size                          = 20M
#    log4perl.appender.LocksLog.max                           = 7
#    log4perl.appender.LocksLog.filename                      = _LOCKSLOGFILE_
#    log4perl.appender.LocksLog.layout                        = Log::Log4perl::Layout::PatternLayout
#    log4perl.appender.LocksLog.layout.ConversionPattern      = %d | %m %n
#    log4perl.appender.LocksLog.mode                          = append
);


sub TOOL_CreateFile {
#---------------------------------------------------------------------
# Create file $source_file to $destination_file
#---------------------------------------------------------------------
    my ($filename, $content) = @_;

    my @file_content = @$content;
    my $create_status = $TRUE;

    LOG_Detailed("TOOL_CreateFile: Creating file $filename");
    if ( open(OUTFILE, ">$filename") ) {
        foreach my $line (@file_content) {
            print OUTFILE "$line\n";
        }
        close(OUTFILE);
   } else {
        LOG_Summary("TOOL_CreateFile: ERROR: Failed to open $filename: $!");
        $create_status = $FALSE;
    }
    return($create_status);
}
 
 
sub TOOL_AppendFile {
#---------------------------------------------------------------------
# Append file $source_file to $destination_file
#---------------------------------------------------------------------
    my ($source_file, $destination_file) = @_;

    my $append_status = $TRUE;

    LOG_Detailed("TOOL_AppendFile: Appending file $source_file to $destination_file");
    if ( open(OUTFILE, ">>$destination_file") ) {
        if ( open(INFILE, "<$source_file") ) {
            print OUTFILE <INFILE>;
            close(INFILE);
        } else {
            LOG_Summary("TOOL_AppendFile: ERROR: Failed to open $source_file: $!");
            $append_status = $FALSE;
        }
        close(OUTFILE);
    } else {
        LOG_Summary("TOOL_AppendFile: ERROR: Failed to open $destination_file: $!");
        $append_status = $FALSE;
    }
    return($append_status);
}


#sub LOG_Operations_Summary {
#---------------------------------------------------------------------
#
# Description:
#
#   Write a string in the OPERATIONS SUMMARY log.
#
# Return value:
#
#   $_[0] : string = message to output in the OPERATIONS SUMMARY log
#
# Return value:
#
#   None
#
# Example:
#
#   LOG_Operations_Summary("DeleteLunNoMap: NO LUN to remove!");
#
#---------------------------------------------------------------------
#    my $string = $_[0];
#
#    if ( $LOG_LEVEL eq "SUMMARY" ) {
#        Log::Log4perl::get_logger("OpsSummary")->info($string);
#        Log::Log4perl::get_logger("Summary")->info($string);
#    } elsif ( $LOG_LEVEL eq "DETAILED" ) {
#        Log::Log4perl::get_logger("OpsSummary")->info($string);
#        Log::Log4perl::get_logger("Summary")->info($string);
#        Log::Log4perl::get_logger("Detailed")->info($string);
#    } elsif ( $LOG_LEVEL eq "DEBUG" ) {
#        Log::Log4perl::get_logger("OpsSummary")->info($string);
#        Log::Log4perl::get_logger("Summary")->info($string);
#        Log::Log4perl::get_logger("Detailed")->info($string);
#        Log::Log4perl::get_logger("Debug")->info($string);
#    }
#
#    if ( ($LOG_SCREEN eq "SUMMARY") or
#         ($LOG_SCREEN eq "DETAILED") or
#         ($LOG_SCREEN eq "DEBUG") ) {
#        Log::Log4perl::get_logger("Screen")->info($string);
#    }
#}


sub LOG_Report_Summary {
#---------------------------------------------------------------------
#
# Description:
#
#   Write a string in the SUMMARY log.
#
# Return value:
#
#   $_[0] : string = message to output in the SUMMARY log
#
# Return value:
#
#   None
#
# Example:
#
#   LOG_Summary("DeleteLunNoMap: NO LUN to remove!");
#
#---------------------------------------------------------------------
    my $string = $_[0];

    if ( $LOG_LEVEL eq "SUMMARY" ) {
        Log::Log4perl::get_logger("Summary")->info($string);
    } elsif ( $LOG_LEVEL eq "DETAILED" ) {
        Log::Log4perl::get_logger("Summary")->info($string);
        Log::Log4perl::get_logger("Detailed")->info($string);
    } elsif ( $LOG_LEVEL eq "DEBUG" ) {
        Log::Log4perl::get_logger("Summary")->info($string);
        Log::Log4perl::get_logger("Detailed")->info($string);
        Log::Log4perl::get_logger("Debug")->info($string);
    }

    if ( ($LOG_SCREEN eq "SUMMARY") or
         ($LOG_SCREEN eq "DETAILED") or
         ($LOG_SCREEN eq "DEBUG") ) {
        Log::Log4perl::get_logger("Screen")->info($string);
    }
}
 

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
    my $string = $_[0];

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


sub LOG_Debug {
#---------------------------------------------------------------------
#
# Description:
#
#   Write a string in the DEBUG log.
#
# Return value:
#
#   $_[0] : string = message to output in the DEBUG log
#
# Return value:
#
#   None
#
# Example:
#
#   LOG_Debug("DeleteLunNoMap: NO LUN to remove!");
#
#---------------------------------------------------------------------
    my $string = $_[0];

    if ( $LOG_LEVEL eq "DEBUG" ) {
        Log::Log4perl::get_logger("Debug")->info($string);
    }

    if ( ($LOG_SCREEN eq "DEBUG") ) {
        Log::Log4perl::get_logger("Screen")->info($string);
    }
}


#sub LOG_Report {
#---------------------------------------------------------------------
#
# Description:
#
#   Write a string in the REPORT log.
#
# Return value:
#
#   $_[0] : string = message to output in the REPORT log
#
# Return value:
#
#   None
#
# Example:
#
#   LOG_Report("DeleteLunNoMap: NO LUN to remove!");
#
#---------------------------------------------------------------------
#    my $string = $_[0];
#	
#    Log::Log4perl::get_logger("Report")->info($string);
#
#    if ( ($LOG_SCREEN eq "REPORT") ) {
#        Log::Log4perl::get_logger("Screen")->info($string);
#    }
#}


sub LOG_Locks {
#---------------------------------------------------------------------
#
# Description:
#
#   Write a string in the LOCK log.
#
# Return value:
#
#   $_[0] : string = message to output in the REPORT log
#
# Return value:
#
#   None
#
# Example:
#
#   LOG_Locks("LOCK_LockResource: ERROR: Missing resource name");
#
#---------------------------------------------------------------------
    my $string = $_[0];
	
    Log::Log4perl::get_logger("Locks")->info($string);

    if ( ($LOG_SCREEN eq "LOCK") ) {
        Log::Log4perl::get_logger("Screen")->info($string);
    }
}


sub LOG_EnableScreenLogger {
#---------------------------------------------------------------------
#
# Description:
#
#   Initialize the specified screen logging level.
#   Valid logging levels are: SUMMARY, DETAILED, DEBUG
#
# Input parameters:
#
#   $_[0] : $level = [ SUMMARY | DETAILED | DEBUG | REPORT ]
#
# Return value:
#
#   Returns $TRUE if logger is enabled, $FALSE otherwise
#
# Examples:
#
#   $status = LOG_EnableScreenLogger("DETAILED");
#
#---------------------------------------------------------------------
    my ($level) = @_;

    if ( defined($level) ) {
        my $level = uc($level);
        if ( $level =~ /^(SUMMARY|DETAILED|DEBUG|REPORT)$/ ) {
            $LOG_SCREEN = $level;
        } else {
            print "*** ERROR: LOG_EnableScreenLogger: Invalid log level: $level\n";
            return($FALSE);
        }
    } else {
        print "*** ERROR: LOG_EnableScreenLogger: Missing logger type\n";
        return($FALSE);
    }
}


sub LOG_EnableLogger {
#---------------------------------------------------------------------
#
# Description:
#
#   Initialize the specified logger. The log file is saved in the Logs
#   ($LOG_DIR) folder.
#
# Input parameters:
#
#   $_[0] : $level = [ SUMMARY | DETAILED | DEBUG ]
#
# Return value:
#
#   Returns $TRUE if logger is enabled, $FALSE otherwise
#
# Examples:
#
#   $status = LOG_EnableLogger("DETAILED");
#
#---------------------------------------------------------------------
    my ($level) = @_;

    my $logger_enabled = $TRUE;
    my $conf;

    if ( defined($level) ) {
        my $level = uc($level);
        if ( $level =~ /^(SUMMARY|DETAILED|DEBUG|REPORT|LOCKS)$/ ) {
            $LOG_LEVEL = $level;
        } else {
            print "*** ERROR: LOG_EnableLogger: Invalid log level: $level\n";
            return($FALSE);
        }
    } else {
        print "*** ERROR: LOG_EnableLogger: Missing logger type\n";
        return($FALSE);
    }

    my $current_log_config = $LOG_CONFIG;
    $current_log_config =~ s/_DEBUGLOGFILE_/$LOG_DIR\/$CURRENT_DEBUG_LOGFILE/g;
    $current_log_config =~ s/_DETAILEDLOGFILE_/$LOG_DIR\/$CURRENT_DETAILED_LOGFILE/g;
    $current_log_config =~ s/_SUMMARYLOGFILE_/$LOG_DIR\/$CURRENT_SUMMARY_LOGFILE/g;
    $current_log_config =~ s/_REPORTLOGFILE_/$LOG_DIR\/$CURRENT_REPORT_LOGFILE/g;
#    $current_log_config =~ s/_LOCKSLOGFILE_/$LOG_DIR\/$STORAGE_LOCKS_LOGFILE/g;
#    $current_log_config =~ s/_OPSSUMMARYLOGFILE_/$LOG_DIR\/$STORAGE_SUMMARY_LOGFILE/g;

    Log::Log4perl::init(\$current_log_config)  or die "Log init failed";
    return($TRUE);
}

 
sub LOG_SetLogFilename {
#---------------------------------------------------------------------
#
# Description:
#
#   Assign the log filename to the requested LOG level
#
# Input parameters:
#
#   $_[0] : $level    = [ SUMMARY | DETAILED | DEBUG | REPORT ]
#   $_[1] : $filename = Log filename
#
# Return value:
#
#   Returns $TRUE if successfull, $FALSE otherwise
#
# Examples:
#
#   $status = LOG_SetLogFilename("DETAILED", "My_detailed_log.txt");
#
#---------------------------------------------------------------------
    my ($level, $filename) = @_;

    my $old_logfile;
    my $new_logfile;

    if ( defined($level) ) {
        my $level = uc($level);
        if ( ! ($level =~ /^(SUMMARY|DETAILED|DEBUG|REPORT)$/) ) {
            print "LOG_SetLogFilename: ERROR: Invalid log level: $level\n";
            return($FALSE);
        }
    } else {
        print "LOG_SetLogFilename: ERROR: Missing logger type\n";
        return($FALSE);
    }

    if ( ! defined($filename) ) {
        print "LOG_SetLogFilename: ERROR: Missing log filename\n";
        return($FALSE);
    }

    if ( $level eq "SUMMARY" ) {
        $CURRENT_SUMMARY_LOGFILE = "$filename";
    } elsif ( $level eq "DETAILED" ) {
        $CURRENT_DETAILED_LOGFILE = "$filename";
    }  elsif ( $level eq "DEBUG" ) {
        $CURRENT_DEBUG_LOGFILE = "$filename";
    }  elsif ( $level eq "REPORT" ) {
        $CURRENT_REPORT_LOGFILE = "$filename";
    }

    my @empty_file = ();
	
    if ( TOOL_CreateFile("$LOG_DIR/$filename", \@empty_file) != $SUCCESS ) {
       print "ERROR: Failed to create file $LOG_DIR/$filename\n";
    }

    if ( $LOG_LEVEL ne "NONE" ) {
        LOG_EnableLogger($LOG_LEVEL);
    }
}


sub LOG_RenameLogFile {
#---------------------------------------------------------------------
#
# Description:
#
#   Rename the log file for the requested LOG level
#
# Input parameters:
#
#   $_[0] : $level    = [ SUMMARY | DETAILED | DEBUG | REPORT ]
#   $_[1] : $filename = New log filename
#
# Return value:
#
#   Returns $TRUE if successfull, $FALSE otherwise
#
# Examples:
#
#   $status = LOG_RenameLogFile("DETAILED", "My_detailed_log.txt");
#
#---------------------------------------------------------------------
    my ($level, $filename) = @_;

    my $old_logfile;
    my $new_logfile;
    my $rename_status = $TRUE;

    if ( defined($level) ) {
        my $level = uc($level);
        if ( ! ($level =~ /^(SUMMARY|DETAILED|DEBUG|REPORT)$/) ) {
            print "LOG_SetLogFilename: ERROR: Invalid log level: $level\n";
            return($FALSE);
        }
    } else {
        print "LOG_SetLogFilename: ERROR: Missing logger type\n";
        return($FALSE);
    }

    if ( ! defined($filename) ) {
        LOG_Summary("LOG_SetLogFilename: ERROR: Missing log filename");
        LOG_Report("LOG_SetLogFilename: ERROR: Missing log filename");
        return($FALSE);
    }
    $new_logfile = "$LOG_DIR/$filename";
    if ( $level eq "REPORT" ) {
        if ( -e $new_logfile ) {
            LOG_Detailed("LOG_RenameLogFilename: New REPORT log file $new_logfile already exists. Deleting it...");
            unlink $new_logfile;
        }
    }
    if ( $level eq "SUMMARY" ) {
        $old_logfile = "$LOG_DIR/$CURRENT_SUMMARY_LOGFILE";
        if ( TOOL_AppendFile($old_logfile, $new_logfile) == $FALSE ) {
            print "LOG_RenameLogFilename: ERROR: Failed to append $old_logfile to $new_logfile\n";
            $rename_status = $FALSE;
        }
        $CURRENT_SUMMARY_LOGFILE = "$filename";
    } elsif ( $level eq "DETAILED" ) {
        $old_logfile = "$LOG_DIR/$CURRENT_DETAILED_LOGFILE";
        if ( TOOL_AppendFile($old_logfile, $new_logfile) == $FALSE ) {
            print "LOG_RenameLogFilename: ERROR: Failed to append $old_logfile to $new_logfile\n";
            $rename_status = $FALSE;
        }
        $CURRENT_DETAILED_LOGFILE = "$filename";
    }  elsif ( $level eq "DEBUG" ) {
        $old_logfile = "$LOG_DIR/$CURRENT_DEBUG_LOGFILE";
        if ( TOOL_AppendFile($old_logfile, $new_logfile) == $FALSE ) {
            print "LOG_RenameLogFilename: ERROR: Failed to append $old_logfile to $new_logfile\n";
            $rename_status = $FALSE;
        }
        $CURRENT_DEBUG_LOGFILE = "$filename";
    }  elsif ( $level eq "REPORT" ) {
        $old_logfile = "$LOG_DIR/$CURRENT_REPORT_LOGFILE";
        if ( TOOL_AppendFile($old_logfile, $new_logfile) == $FALSE ) {
            print "LOG_RenameLogFilename: ERROR: Failed to append $old_logfile to $new_logfile\n";
            $rename_status = $FALSE;
        }
        $CURRENT_REPORT_LOGFILE = "$filename";
    }

    LOG_EnableLogger($LOG_LEVEL);
    if ( $rename_status == $TRUE ) {
        unlink $old_logfile if -e $old_logfile;
    }
    return($rename_status);
}
1;
