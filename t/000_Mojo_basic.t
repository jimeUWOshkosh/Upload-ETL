use Mojo::Base -strict;

#use Test::Most 'no_plan';
use Test::More 'no_plan';
use Test::Mojo;
use lib 'lib';
our $VERSION = '1.00';

my $t = Test::Mojo->new('Up');
$t->get_ok('/')->status_is(200)->content_like(qr/Upload Menu System/i);

done_testing();
1;
