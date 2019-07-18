use strict;
use warnings;
use feature 'say';
use lib 'lib';
use Test::More 'no_plan';
use WWW::Mechanize ();
my $mech = WWW::Mechanize->new();

our $VERSION = '1.00';

my $url = 'http://127.0.0.1:3000/';
$mech->get($url);

ok( $mech->success() == 1, 'Got the main page' );

# See if link on Menu page works
$mech->follow_link( n => 1 );
ok( $mech->success() == 1,                    'Back to Upload Menu' );
ok( $mech->uri() eq 'http://127.0.0.1:3000/', 'Correct URI for Upload Menu' );
#like( $mech->content, qr/<h2>Menu/i, 'Correct HTML Paragrah in Upload Menu' );
like( $mech->content, qr/<title>Upload Menu System/i, 'Correct HTML title in Upload Menu' );

# Goto Upload a file
$mech->submit_form(
    form_number => 1,
    fields      => {
        select => 'file_upload',
        button => 'Enter',
    }
);

ok( $mech->success() == 1, 'Choosing file(s) to upload to DBMS' );
ok(
    $mech->uri() eq 'http://127.0.0.1:3000/FileUpload',
    'Correct URI for Choosing File(s) to Upload'
);
like(
    $mech->content,
    qr/<p>Choose file\(s\) to upload/,
    'Correct HTML Paragrah in Choosing File(s) Upload'
);

# See if link on page goes back to Upload Menu
$mech->follow_link( n => 1 );
ok( $mech->success() == 1,                    'Back to Upload Menu' );
ok( $mech->uri() eq 'http://127.0.0.1:3000/', 'Correct URI for Upload Menu' );
#like( $mech->content, qr/<h2>Menu/i, 'Correct HTML Paragrah in Upload Menu' );
like( $mech->content, qr/<title>Upload Menu System/i, 'Correct HTML title in Upload Menu' );

# Goto Choose an Uploaded file to View
$mech->submit_form(
    form_number => 1,
    fields      => {
        select => 'biglist',
        button => 'Enter',
    }
);

ok( $mech->success() == 1, 'Show files names uploaded to the DBMS' );
ok(
    $mech->uri() eq 'http://127.0.0.1:3000/biglist',
    'Correct URI for Choosing Uploaded File to View'
);
like(
    $mech->content,
    qr/Choose An Upload to view/,
    'Correct HTML Paragrah in Choosing File to View'
);

# See if link on page goes back to Upload Menu
$mech->follow_link( n => 1 );
ok( $mech->success() == 1,                    'Back to Upload Menu' );
ok( $mech->uri() eq 'http://127.0.0.1:3000/', 'Correct URI for Upload Menu' );
#like( $mech->content, qr/<h2>Menu/i, 'Correct HTML Paragrah in Upload Menu' );
like( $mech->content, qr/<title>Upload Menu System/i, 'Correct HTML title in Upload Menu' );

done_testing();
1;
