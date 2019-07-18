#!/usr/bin/env perl
use strict; use warnings;
use feature 'say';

my @files;
push @files , { name => 'stuff', size => 2};
push @files , { name => 'carp',  size => 3};

my $x = shift @files;
use Data::Dumper;
say Dumper(\$x);


exit 0;
