package Modulino;
use strict; use warnings; use utf8; use Perl6::Say; use lib 'lib';
our $VERSION = '1.00';
use MyConfig 'GetDSNinfo';

BEGIN { require Exporter;           our $VERSION = '1.00';
        our @ISA   = qw(Exporter);  our @EXPORT  = qw(perform);
}

script() if not caller();

sub script {
   say 'script'; my ($db);
#   GetOpt::Long stuff
    my ($dsn,$u,$p,$extra) = GetDSNinfo();
    say $extra;
#   my $db  = Up::Schema->connect($dsn,$u,$p,$extra);
   my $rc = mymain( $db );
   exit 0;
}

# file used as a module with subroutine 'perform'
sub perform {
   say 'perform'; my ( $db ) = @_;
   my $rc = mymain($db);
   return $rc;
}

# main body of the program whether called as a program or a module method
sub mymain {
   say 'mymain'; my ($db) = @_;
   my ($rc);
   return $rc;
}
1;
__END__ 

