#!/usr/bin/env perl
use strict; use warnings;

use feature 'say';
foreach ( 1, 3, 7 ) {
   say "\$_ is $_";
   $_ = 1;
}

exit 0;
