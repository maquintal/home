package Functions;

our $VERSION = '1.00';

require Exporter; 

our @ISA = qw(Exporter); 

our %EXPORT_TAGS = ( 'all' => [ qw(
          SUCCESS
		  FAILED
) ] ); 

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
          SUCCESS
		  FAILED
);
 
sub SUCCESS {
	my $SUCCESS = 0;
	return($SUCCESS);
}
 
#1;