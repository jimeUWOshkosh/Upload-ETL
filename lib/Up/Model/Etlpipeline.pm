package Up::Model::Etlpipeline;
#
#   A modulino that reads in a CSV file and insert data into the RDBMS
#
use strict;
use warnings;
use feature 'say';
use utf8::all;
use feature qw(signatures);
no warnings qw(experimental::signatures);    ## no critic
use Carp 'croak';
use English;
our $VERSION = '1.00';

use Ouch;
use lib 'lib';
use DBIx::Class::Storage::TxnScopeGuard;
use Getopt::Long qw(GetOptions);
use File::Basename;
use Data::Dumper;
use Up::Schema;
use MyConfig 'GetDSNinfo';
use ETL::Pipeline;
use Dbrec;
#use Try::Tiny;

our ( $print_rc, );    # for perlcritic
our ( $JT, $JE ) = ( 0, 0 );    # to prove to JT that Ouch's barf != die $@

# is the file called as a program or a module subroutine???
script() if not caller;

# validate arguments to program and call the main body
sub script {

    #   say 'called as script';

    my $filename;
    my $help = 0;

    GetOptions(
        'file|f=s' => \$filename,
        'help|h'   => \$help
    ) or croak('Error in command line arguments');

    if ( ($help) or ( not defined $filename ) ) {
        $print_rc = print {*STDOUT} <<'EOM';

      Usage Etlpipeline.pm [-h] [-f file ]
        -h: this help message
        -f: CSV to be processed

      file must to in the ./uploaded sub-directory

      example: Etlpipeline.pm -f aaa.csv
EOM
        exit 0;
    }

    if ( not( -e "./uploaded/$filename" ) ) {
        croak "file: '$filename' , does not exist";
    }

    my ( $dsn, $u, $p, $extra ) = GetDSNinfo('up.conf');
    my $dbh = Up::Schema->connect( $dsn, $u, $p, $extra )
        or croak 'failed to connect to SQLite3 database. ', Up::Schema::errstr();

    my $dbrec = Dbrec->new( dt => $dbh, mesg => 'dummy' );
    eval {
        mymain( $filename, $dbrec );
        1;
    } or do {
        $print_rc = say 'mymain' if ($JE);
        barf if ($JT);
        croak $EVAL_ERROR;
    };
    exit 0;
}

# file used as a module with subroutine 'perform'
sub perform ( $file, $dbh ) {

    #   say 'perform';
    #   my ($file ) = @_;
    my $dbrec = Dbrec->new( dt => $dbh, mesg => 'dummy' );
    eval {
        mymain( $file, $dbrec );
        1;
    } or do {
        $print_rc = say 'perform' if ($JE);
        barf if ($JT);
        croak $EVAL_ERROR;
    };
    return 1;
}

sub mymain ( $name, $dbrec ) {

    #   say 'mymain';

    # the file is sitting in the ./upload, put in ./tmp to process
    my $suffix   = lc $+{suffix} if ( $name =~ m/\A\w.*\.(?<suffix>\w.*)\Z/ );    ## no critic
    my $filename = './uploaded/' . $name;

#    my $tmp_fn;
    # copy file to tmp
    my $tmp_fn = './tmp/' . $name;
    `cp $filename $tmp_fn`;
    my ($guard);
    eval {
        my $tmp = $dbrec->dt;
        $guard = $tmp->txn_scope_guard;                                           # BEGIN_TRANSACTION();
        if ( $suffix eq 'csv' ) {
            pipelineCSV( $name, $dbrec );
            `rm $tmp_fn`;
        }
        elsif ( $suffix eq 'xls' ) {
            pipelineExcel( $name, $dbrec );
#            pipelineXLS( $name, $dbrec );
            `rm $tmp_fn`;
        }
        elsif ( $suffix eq 'xlsx' ) {
            pipelineExcel( $name, $dbrec );
#            pipelineXLSX( $name, $dbrec );
            `rm $tmp_fn`;
        }
        else {
            ouch 404, 'File extension NOT valid';
        }
        1;
    } or do {
        $print_rc = say 'mymain' if ($JE);
        barf if ($JT);
        croak $EVAL_ERROR;
    };
    $guard->commit;    # END_TRANSACTION();
    return;
}

sub pipelineExcel ( $in_fn, $dbrec ) {
    eval {
        my $etl = ETL::Pipeline->new(
            {
                work_in => 'tmp',
                input   => ['Excel', matching => $in_fn],
                mapping => {name => 'A', age => 'B', utf => 'C'},
                output  => ['+Local::EEcommon001', dbinfo => $dbrec]
            }
        )->process;
        1;
    } or do {
        $print_rc = say 'pipelineXLSX' if ($JE);
        barf if ($JT);
        croak $EVAL_ERROR;
    };
    return;
}

sub pipelineCSV ( $in_fn, $dbrec ) {
    eval {
        my $etl = ETL::Pipeline->new(
            {
                work_in => 'tmp',
                input   => ['+Local::DelimitedTextUnicode', matching => $in_fn],
                mapping => {name => '0', age => '1', utf => '2'},
                output  => ['+Local::EEcommon001', dbinfo => $dbrec]
            }
        )->process;
#	ouch("SQL Error", $dbrec->mesg) if ($dbrec->mesg ne "dummy");
        1;
    } or do {
        $print_rc = say 'pipelineCSV' if ($JE);
        barf if ($JT);
        croak $EVAL_ERROR;
    };
    return;
}

1;

=head1 NAME

Up::Model::Etlpipeline

A modulino that sends CSV, XLS, and XLSX files to a ETL pipeline 
which will filter the data and insert data into the RDBMS

=head1 VERSION

This document describes Etlpipeline version 1.00

=head1 SYNOPSIS

       use <Up::Model::Etlpipeline;
       Up::Model::Etlpipeline::perform( file, database handle );
   OR
       $ perl lib/Up/Model/Etlpipeline.pm -f file.csv


=head1 DESCRIPTION

  Will take the input(CSV,XLS,XLSX) selected by the user and 
  send to an ETL pipeline to insert into the Upload project's RDBMS

=head1 SUBROUTINES/METHODS

The only subroutine that should be called is

       Up::Model::Etlpipeline::perform( file, database handle );


=head2 script

If called from the command line, subroutine 'script' starts off the program

       $ perl lib/Up/Model/Etlpipeline.pm -f file.csv

=head2 perform

If called as a subroutine, subroutine 'perform' is the entry.

       Up::Model::Etlpipeline::perform( file, database handle );

=head2 mymain

[private] Is the main driver of the modulino that both 'script' and 'perform' 
subroutines call

=head2 pipelineCSV

[private] Is called when a CSV file is being processed. Will call the 
ETL::Pipeline constructor to handle input and output

=head2 pipelineExcel

[private] Is called when a Excel (XLS, XLSX) file is being processed. Will 
call the ETL::Pipeline constructor to handle input and output

=head1 DIAGNOSTICS

=head2 Possible errors

=head3 As a script

  Failed to find configuration file
  Failed to connect to database
 
=head3 modulino

  The CSV file has the wrong format
  The Excel spreadsheet has a bad extension name based on contents
  The ETL::Pipeline Input module does NOT exist
  The ETL::Pipeline Output module does NOT exist
  Other ETL::Pipeline errors during construction

=head1 CONFIGURATION AND ENVIRONMENT

The configuration file for this Mojolicious application is 'up.conf' in
the project's home directory.

The file to be ETL needs to be placed in the {$PROJECT}/uploaded 
sub-directory and will be copied to {$PROJECT}/tmp to be processed.

=head1 DEPENDENCIES

Carp
English
Ouch
DBIx::Class::Storage::TxnScopeGuard
Getopt::Long
File::Basename

View CPAN.DEPENDENCIES in the project's home directory

=head1 INCOMPATIBILITIES

None to be reported at this time

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

Please report problems.

Patches are welcome.

Contact via github account you found this code at.

=head1 AUTHOR

Jim Edwards

=head1 LICENCE AND COPYRIGHT

Since this a proof of concept there is no license or copyright.

Help other Perl programmers out by posting full examples
of your hard testing/work to a github like repository.

