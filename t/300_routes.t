use lib 'lib';
use Mojo::Base -strict;
use Test::More 'no_plan';
use Test::Mojo;
our $VERSION = '1.00';

# Show menu page
my $t = Test::Mojo->new('Up');
$t->get_ok('/')->status_is(200)->content_type_like(qr{text/htm});

# Pick a file to upload into the DBMS
$t->get_ok('/FileUpload')->status_is(200)->content_type_like(qr{text/html});

# Show the 'biglist' of files loaded into the DBMS
$t->get_ok('/biglist')->status_is(200)->content_type_like(qr{text/html});
done_testing();
1;
