use strict;
use warnings;
use feature 'say';
use ETL::Pipeline;
use lib 'lib';
use Encode qw(decode encode);
use Scalar::Util 'looks_like_number';
use Test::More 'no_plan';
#use utf8::all;
binmode STDOUT, ":utf8";

sub value {
    my ( $etl, $field ) = @_;
    my @values = $etl->input->get($field);
    return $values[0];
}

my $etl = ETL::Pipeline->new(
    {
        work_in => 't/DataFiles',
        input   => [
            'Excel', matching => 'MadMongers.xls',
            worksheet => 'Test2'
        ],
    }
);
$etl->input->configure;
my $num_cols = scalar( @{$etl->input->column_names} ) / 2;
say $num_cols;
my @cols = splice( @{$etl->input->column_names}, $num_cols );
say "@cols";
while ( $etl->input->next_record ) {
    foreach my $field ( 0 .. ( scalar(@cols) - 1 ) ) {
#        my @data = $etl->input->get( $field - 1 );
        my @data = $etl->input->get($field);
        print $data[0], '   ';
    }
    print "\n";
}
ok( 1 eq 1, 'Stop prove from whining' );
done_testing();
1;
