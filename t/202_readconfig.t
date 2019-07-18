#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use Test::Most 'no_plan';
use Test::Exception;
use FindBin::libs;
use Config::Any::Perl;

our $VERSION = '1.00';

my @files;
$files[0] = 'up.conf';

my $cfg = Config::Any::Perl->load( $files[0] );
ok(
    $cfg->{DSN} eq 'DBI:SQLite:dbname=db/up.db',
    'We got the DBI info'
);

done_testing();
1;
