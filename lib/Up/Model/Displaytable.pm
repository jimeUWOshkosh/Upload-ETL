package Up::Model::Displaytable;
use strict;
use warnings;
use utf8;
use feature 'say';
use feature qw(signatures);
no warnings qw(experimental::signatures);    ## no critic
use Carp 'croak';
use English;
our $VERSION = '1.00';
use Try::Tiny;
use Ouch;
use lib 'lib';
use DBIx::Class::Storage::TxnScopeGuard;
use Getopt::Long;

use HTML::Table;

use Up::Schema;
use MyConfig 'GetDSNinfo';

our $print_rc;

# is the file called as a program or a module sub routine???
script() if not caller;

# validate arguments to program and call the main body
sub script {

    #   say 'called as script';

    my $file_id;
    my $help = 0;

    GetOptions(
        'file=i' => \$file_id,
        'help'   => \$help
    ) or croak('Error in command line arguments');

    if ( ($help) or ( not defined $file_id ) ) {
        $print_rc = print {*STDOUT} <<'EOM';

      Usage Display.pm [-h] [-f file_id ]
        -h: this help message
        -f: file_id of upload

      example: Display.pm -f 1
EOM
        exit 0;
    }

    my ( $dsn, $u, $p, $extra ) = GetDSNinfo('up.conf');
    my $db = Up::Schema->connect( $dsn, $u, $p, $extra );
    my ($guard);
    try {
        $guard = $db->txn_scope_guard;    # BEGIN_TRANSACTION
        my @wrksheet = $db->resultset('Datasheet')->search(
            {file_id => $file_id,},
            {
                columns  => [qw/ sheet_id sheet_name/],
                order_by => [qw/ sheet_id /],
            },
        );
        if ( not( scalar @wrksheet ) ) { ouch 404, 'File Id not found'; }
    }
    catch {
        croak "Error: $_";
    };
    $guard->commit;    # END_TRANSACTION

    my $txt = mymain( $file_id, $db );
    $print_rc = say $txt;

    exit 0;
}

# file used as a module with method 'perform'
sub perform ( $file_id, $db ) {
    my $txt = mymain( $file_id, $db );
    return $txt;
}

# main body of the program whether called as a program or a module sub routine
sub mymain ( $file_id, $db ) {
    my ( $guard, $txt );
    try {
        $guard = $db->txn_scope_guard;    # BEGIN_TRANSACTION
        my @wrksheet = $db->resultset('Datasheet')->search(
            {file_id => $file_id,},
            {
                columns  => [qw/ sheet_id sheet_name/],
                order_by => [qw/ sheet_id /],
            },
        );
        for my $sheet (@wrksheet) {

            #         $txt .= "<h3>" . $sheet->sheet_name . "</h3>";
            my @data = $db->resultset('Data')->search(
                {
                    file_id  => $file_id,
                    sheet_id => $sheet->sheet_id,
                },
                {order_by => [qw/ data_id /],},
            );

            my $header = ['name', 'age', 'utf'];    # $header = shift @$matrix;

            my $col   = 3;                          # my $col = scalar @$header;
            my $table = HTML::Table->new(
                -cols    => $col,
                -border  => 1,
                -padding => 1,
                -head    => $header,
            );
            for my $d (@data) {
                my $ra = [$d->name, $d->age, $d->utf];
                $table->addRow(@$ra);
            }

            $txt .= $table . '<br></br>' . q(<a href="/biglist">View Additional Uploaded Files</a><br></br>);
        }
    }
    catch {
        croak "Error: $_";
    };
    $guard->commit;    # END_TRANSACTION
    return $txt;

}
1;

=head1 NAME

Up::Model::Displaytable - Return the selcted file that was ETL'd into a database as a html table.

=head1 VERSION

This documentation refers to Displaytable version 1.00

=head1 SYNOPSIS

       use <Up::Model::Displaytable;
       Up::Model::Displaytable::perform( file_id, database handle );
   OR
       $ perl lib/Up/Model/Displaytable.pm -f file_id


=head1 DESCRIPTION

Return the selcted file that was ETL'd into a database as a html table.

=head1 SUBROUTINES/METHODS

The only subroutine that should be called is

my $txt = Up::Model::Displaytable::perform( $file_id, $db );

=head2 script

If called from the command line, subroutine 'script' starts off the program

       $ perl lib/Up/Model/Displaytable.pm -f file_id

=head2 perform

If called as a subroutine, subroutine 'perform' is the entry.

       Up::Model::Displaytable::perform( file_id, database handle );

=head2 mymain

[private] Is the main driver of the modulino that both 'script' and 'perform' 
subroutines call. 

=head1 DIAGNOSTICS

=head2 Possible errors

=head3 As a script

  Failed to find configuration file
  Failed to connect to database

=head3 modulino

  Bad DBIx::Class calls
  Bad data used in HTML::Table construction

=head1 CONFIGURATION AND ENVIRONMENT

The configuration file for this Mojolicious application is 'up.conf' in
the project's home directory.

=head1 DEPENDENCIES

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

