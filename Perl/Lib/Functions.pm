package Functions;

our $VERSION = '1.00';

require Exporter; 

our @ISA = qw(Exporter); 

our %EXPORT_TAGS = ( 'all' => [ qw(
          add
		  multiply
) ] ); 

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
          add
		  multiply
);
 
use Global;
 
sub add {
  my ($x, $y) = @_;
  my $sub_status = $SUCCESS;
  
  $res = $x + $y;
  
  return($sub_status, $res);
}
 
sub multiply {
  my ($x, $y) = @_;
  return $x * $y;
}
 
1;