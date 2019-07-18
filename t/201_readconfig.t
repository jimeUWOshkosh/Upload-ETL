#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use Test::Most 'no_plan';
use Test::Exception;
use FindBin::libs;
use Config::Any;
our $VERSION = '1.00';

my @files;
$files[0] = 'up.conf';

my $cfg    = Config::Any->load_files( {files => \@files, use_ext => 1} );
my $h      = $cfg->[0];
my $h1     = $h->{'up.conf'};
my %config = %{$h1};
ok( 1 eq 1, 'Stop prove from whining' );
done_testing();
1;
