#!/usr/bin/env perl
use strict; use warnings;
use feature 'say';


my $x = "Tim O'Reilly";
$x = "Tim O\"Reilly";
$x =~ s/('|")/\\$1/ag;
say $x;
exit 0;
