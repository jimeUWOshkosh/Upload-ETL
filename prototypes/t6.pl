#!/usr/bin/env perl
use strict; use warnings;
use feature 'say';
my $name = 'aaa.CSV';
my $suffix;
$suffix = lc $+{suffix} if ($name =~ m/\A\w.*\.(?<suffix>\w.*)\Z/);
say $suffix;
{
use File::Basename;

my($filename, $dirs, $suffix) = fileparse('./uploaded/aaa.csv');
say $filename, '|', $suffix, '|';

}


exit 0;
