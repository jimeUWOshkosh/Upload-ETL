package Stuff;
use Moose;
use MooseX::Types::LoadableClass;
has dbh => (
   is  => 'ro',
   isa => 'Object',
);
package main;
use strict; use warnings;
use lib 'lib';
use Up::Schema;
use Up::Schema;
use MyConfig 'GetDSNinfo';

my ($dsn,$u,$p,$extra) = GetDSNinfo('up.conf');
my $dbh  = Up::Schema->connect($dsn,$u,$p,$extra);

my $x = Stuff->new( dbh => $dbh );
