#!/usr/bin/env perl
use strict; use warnings;
use feature 'say';
use Carp 'croak';
use Getopt::Long;

use Modulino 'perform';

my $db;
perform($db);

exit 0;
