use strict; use warnings; use feature 'say';
use ETL::Pipeline;
use Test::Most;
use lib 'lib';


my $etl = ETL::Pipeline->new( {
	input => ['Excel', file => 'madmongers.xls']
} );
$etl->input->configure;
if  (defined $etl->input->record) {
    foreach my $field (0 .. 2) {
#        my @data = $etl->input->get( $field - 1 );
        my @data = $etl->input->get( $field );
        say $data[0];
    }
}


$etl->input->next_record;

	is( $etl->input->number_of_fields, 5, 'Five columns' );
	foreach my $field (1 .. 3) {
		my @data = $etl->input->get( $field - 1 );
		is( $data[0], "Field$field", "Found Field$field" );
	}

subtest 'Second record' => sub {
	ok( $etl->input->next_record, 'Whitespace allowed' );
	ok( defined $etl->input->record, 'Record has data' );
};

is( $etl->input->next_record, 0, 'End of file reached' );
$etl->input->finish;

done_testing;
