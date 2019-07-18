#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use Test::Most 'no_plan';
use Test::Exception;
use FindBin::libs;
use Readcsv;

our $VERSION = '1.00';
throws_ok(
    sub { Readcsv::perform('test.csv'); },
    qr/No such file or directory/,
    'Exception caught for Bad File'
);

ok( Readcsv::perform('toupload/aaa.csv'), 'Ran ok' );
done_testing();
exit 0;
