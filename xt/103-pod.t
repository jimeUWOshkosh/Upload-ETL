use strict;
use warnings;
use Test::More;
use English;
use lib 'lib';

our $VERSION = '0.01';

# Stolen from Catalyst MVC project generator output

plan skip_all => 'set TEST_POD to enable this test' unless $ENV{TEST_POD};

#eval 'use Test::Pod 1.14';
eval 'use Test::Pod';
plan skip_all => 'Test::Pod 1.14 required' if $EVAL_ERROR;

#eval 'use Pod::Coverage 0.20';
#plan skip_all => 'Pod::Coverage 0.20 required' if $EVAL_ERROR;
#all_pod_files_ok();

use Test::Pod::Coverage;
all_pod_coverage_ok({ coverage_class => 'Pod::Coverage::Moose'});
