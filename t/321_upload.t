use strict;
use warnings;
use feature 'say';
use lib 'lib';
use Test::More 'no_plan';
use Test::WWW::Mechanize ();
use FindBin::libs;
use MyConfig 'GetDSNinfo';
use Carp 'croak';
use DBI;

# 321_upload.t
# Test uploading and displaying a CSV file via the web pages
our $VERSION = '1.00';

# Delete data from tables so to guarantee the file_id equal 1
# connect to RDBMS
#  DSN => "DBI:SQLite:dbname=db/up.db",
#  USER => "",    PASSWORD => "",
#  DBEXTRA => { sqlite_unicode => 1 },
my ( $dsn, $u, $p, $extra ) = GetDSNinfo('up.conf');
my $dbh = DBI->connect( $dsn, $u, $p, $extra );

# delete info in tables
my $sth;
$sth = $dbh->do(
#    qq{ DELETE FROM Data }
    q{ DELETE FROM Data }
) or croak $dbh->errstr;

$sth = $dbh->do(
#    qq{ DELETE FROM Dataset }
    q{ DELETE FROM Dataset }
) or croak $dbh->errstr;

$sth = $dbh->do(
#    qq{ DELETE FROM Datasheet }
    q{ DELETE FROM Datasheet }
) or croak $dbh->errstr;

my $mech = Test::WWW::Mechanize->new();
my $url  = 'http://127.0.0.1:3000/';
$mech->get_ok( $url, 'Got the main page' );

# Goto Upload a file
$mech->submit_form_ok(
    {
        form_number => 1,
        fields      => {
            select => 'file_upload',
            button => 'Enter',
        },
    },
    'Choosing file(s) to upload to DBMS'
);

ok(
    $mech->uri() eq 'http://127.0.0.1:3000/FileUpload',
    'Correct URI for Choosing File(s) to Upload'
);
$mech->content_like(
    qr/<p>Choose file\(s\) to upload/,
    'Correct HTML Paragrah in Choosing File(s) Upload'
);

# Goto Upload a file
$mech->submit_form_ok(
    {
        form_number => 1,
        fields      => {
            files  => qw( aaaa.csv ),
            button => 'Submit',
        },
    },
    'Upload file aaaa.csv'
);

# See if 1st link on Post Upload File(s) page works, back to Upload File(s)
$mech->follow_link_ok( {n => 1}, 'Choosing file(s) to upload to DBMS' );
ok(
    $mech->uri() eq 'http://127.0.0.1:3000/FileUpload',
    'Correct URI for Choosing File(s) to Upload'
);
$mech->content_like(
    qr/<p>Choose file\(s\) to upload/,
    'Correct HTML Paragrah in Choosing File(s) Upload'
);

# Goto Upload a file
$mech->submit_form_ok(
    {
        form_number => 1,
        fields      => {
            files  => qw( aaaa.csv ),
            button => 'Submit',
        },
    },
    'Upload file aaaa.csv'
);

# See if 2nd link on Post Upload File(s) page works, back to Upload Menu page
$mech->follow_link_ok( {n => 2}, 'Follow link back to Upload Menu' );
ok( $mech->uri() eq 'http://127.0.0.1:3000/', 'Correct URI for Upload Menu' );
#$mech->content_like( qr/<h2>Menu/i, 'Correct HTML Paragrah in Upload Menu' );
$mech->content_like( qr/<FORM ACTION=\"UploadMenuChose/i, 'Correct HTML Paragrah in Upload Menu' );

# Go to Display spreadsheet select
$mech->submit_form_ok(
    {
        form_number => 1,
        fields      => {
            select => 'biglist',
            button => 'Enter',
        },
    },
    'Choosing file to stored in the DBMS to display'
);

# Display file with file_id equal to 1.
$mech->submit_form_ok(
    {
        form_number => 1,
        fields      => {
            listname => 1,
            button   => 'Submit',
        },
    },
    'Choosing file to stored in the DBMS to display'
);

ok(
    $mech->uri() eq 'http://127.0.0.1:3000/displaydataset',
    'Correct URI for Displaying a file'
);

done_testing();
1;
