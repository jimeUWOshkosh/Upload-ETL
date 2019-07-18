#!/usr/bin/env perl
use strict; use warnings;
use feature 'say';
use Carp 'croak';
use Getopt::Long;

my $filename;
my $help=0;

GetOptions ( "file=s" => \$filename,    
             "help"   => \$help)
  or croak("Error in command line arguments");

if ( ($help) or (not defined $filename) ) {
   print STDOUT <<EOM;

   Usage Readcsv.pm [-h] [-f file ]
     -h: this help message
     -f: CSV file to be processed

   example: Readcsv.pm -f aaa.csv
EOM

   exit 0;
}

if (not (-e $filename)) {
   croak "file: '$filename' , does not exist";
}
exit 0;
