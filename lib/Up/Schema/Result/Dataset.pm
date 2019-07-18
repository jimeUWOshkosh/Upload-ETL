use utf8;

package Up::Schema::Result::Dataset;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Up::Schema::Result::Dataset

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<dataset>

=cut

__PACKAGE__->table("dataset");

=head1 ACCESSORS

=head2 file_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 file

  data_type: 'text'
  is_nullable: 0

=head2 transaction_date

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
    "file_id",
    {data_type => "integer", is_auto_increment => 1, is_nullable => 0},
    "file",
    {data_type => "text", is_nullable => 0},
    "transaction_date",
    {
        data_type     => "timestamp",
        default_value => \"current_timestamp",
        is_nullable   => 1,
    },
);

=head1 PRIMARY KEY

=over 4

=item * L</file_id>

=back

=cut

__PACKAGE__->set_primary_key("file_id");

=head1 RELATIONS

=head2 datas

Type: has_many

Related object: L<Up::Schema::Result::Data>

=cut

__PACKAGE__->has_many(
    "datas", "Up::Schema::Result::Data",
    {"foreign.file_id" => "self.file_id"},
    {cascade_copy      => 0, cascade_delete => 0},
);

=head2 datasheets

Type: has_many

Related object: L<Up::Schema::Result::Datasheet>

=cut

__PACKAGE__->has_many(
    "datasheets",
    "Up::Schema::Result::Datasheet",
    {"foreign.file_id" => "self.file_id"},
    {cascade_copy      => 0, cascade_delete => 0},
);

# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-06-16 01:52:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:w7SrtSgRJFaV+VppRuLejg

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

=head1 DIAGNOSTICS

You should get errors when you try to use an invalid attribute

=head1 CONFIGURATION AND ENVIRONMENT

The configuration file for this Mojolicious application is 'up.conf' in
the project's home directory.

=head1 DEPENDENCIES

Moose, namespace::autoclean

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

=cut

__END__
