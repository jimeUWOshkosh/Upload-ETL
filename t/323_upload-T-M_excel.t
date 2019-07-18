use strict;
use warnings;
use feature 'say';
use lib 'lib';
use Mojo::Base -strict;
use Test::More 'no_plan';
use Test::Mojo;
use Test::WWW::Mechanize;
use Test::WWW::Mechanize::Mojo;
use MyConfig 'GetDSNinfo';
use Carp 'croak';
use Try::Tiny;
use DBI;

our $VERSION = '1.00';

# Test::Mojo suite
#   Upload a XLS/XLSX file and display it
#   Note: The Upload File webpage can process a list of files.
#         WWW::Mechanize can NOT

# Delete data from tables so to guarantee the file_id equal 1
# connect to RDBMS
#  DSN => "DBI:SQLite:dbname=db/up.db",
#  USER => "",    PASSWORD => "",
#  DBEXTRA => { sqlite_unicode => 1 },

my ( $dsn, $u, $p, $extra, $dbh );
try {
    ( $dsn, $u, $p, $extra ) = GetDSNinfo('up.conf');
    $dbh = DBI->connect( $dsn, $u, $p, $extra );
}
catch {
    croak $_ ;    # rethrow
};

try {
    # delete info in tables
    my $sth;
    $sth = $dbh->do(q{ DELETE FROM Data });

    $sth = $dbh->do(q{ DELETE FROM Dataset });

    $sth = $dbh->do(q{ DELETE FROM Datasheet });
}
catch {
    croak $_ ;    # rethrow
};

my $tester = Test::Mojo->new('Up');
my $mech   = Test::WWW::Mechanize::Mojo->new( tester => $tester );

# Show menu page
$mech->get_ok('/');

# Goto Upload a file
$mech->submit_form_ok(
    {
        form_name => 'form1',
        fields    => {
            select => 'file_upload',
            button => 'Enter',
        },
    },
    'Choosing file(s) to upload to DBMS'
);

ok(
    $mech->uri() eq 'http://localhost/FileUpload',
    'Correct URI for Choosing File(s) to Upload'
);
$mech->content_like(
    qr/<p>Choose file\(s\) to upload/,
    'Correct HTML Paragrah in Choosing File(s) Upload'
);

# Goto Upload a file
$mech->submit_form_ok(
    {
        form_name => 'form1',
        fields    => {
            files  => 'mongers.xls',
            button => 'Submit',
        },
    },
    'Upload file mongers.xls'
);

# See if 1st link on Post Upload File(s) page works, back to Upload File(s)
$mech->follow_link_ok( {n => 1}, 'Choosing file(s) to upload to DBMS' );
ok(
    $mech->uri() eq 'http://localhost/FileUpload',
    'Correct URI for Choosing File(s) to Upload'
);
$mech->content_like(
    qr/<p>Choose file\(s\) to upload/,
    'Correct HTML Paragrah in Choosing File(s) Upload'
);

# Goto Upload a file
$mech->submit_form_ok(
    {
        form_name => 'form1',
        fields    => {
            files  => 'mongerss.xlsx',
            button => 'Submit',
        },
    },
    'Upload file mongerss.xlsx'
);

# See if 2nd link on Post Upload File(s) page works, back to Upload Menu page
$mech->follow_link_ok( {n => 2}, 'Follow link back to Upload Menu' );
ok( $mech->uri() eq 'http://localhost/', 'Correct URI for Upload Menu' );

# Go to Display spreadsheet select
$mech->submit_form_ok(
    {
        form_name => 'form1',
        fields    => {
            select => 'biglist',
            button => 'Enter',
        },
    },
    'Choosing file to stored in the DBMS to display'
);

# Display file with file_id equal to 1.
$mech->submit_form_ok(
    {
        form_name => 'form1',
        fields    => {
            listname => 1,
            button   => 'Display',
        },
    },
    'Choosing file to stored in the DBMS to display'
);

ok(
    $mech->uri() eq 'http://localhost/displaydataset',
    'Correct URI for Displaying a file'
);

$mech->follow_link_ok( {n => 1}, 'Follow link back to View Upload Files' );

# Display file with file_id equal to 2.
$mech->submit_form_ok(
    {
        form_name => 'form1',
        fields    => {
            listname => 2,
            button   => 'Submit',
        },
    },
    'Choosing file to stored in the DBMS to display'
);

done_testing();
1;
