package dbh;
use Moose;
has 'stuff', is => 'rw', isa => 'Int';

package DBrec;
use Moose;
use MooseX::Types::LoadableClass;
has 'mesg', is => 'rw', isa => 'Str';
has 'dbhandle',  is => 'rw', isa => 'Object';

package ETLpipeline;
use Moose;
use DBrec;
has 'dbinfo' => ( is => 'ro', isa => 'DBrec', required => 1,);

package main;
use lib 'lib';
use feature 'say';
use MyConfig 'GetDSNinfo';
use Up::Schema;
#my ( $dsn, $u, $p, $extra ) = GetDSNinfo('up.conf');
#my $db  = Up::Schema->connect($dsn,$u,$p,$extra);

my $dbh   = dbh->new( stuff => 77 );
my $dbrec = DBrec->new( mesg => 'dummy', dt => $dbh );

my $etl = ETLpipeline->new( dbinfo => $dbrec );

my $i =0;

exit 0;


