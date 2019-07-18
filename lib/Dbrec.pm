package Dbrec;
# use strict; Moose brings in strict
# use warnings; Moose brings in warnings
use Moose;
use namespace::autoclean;

our $VERSION = '1.00';

=head1 NAME

Dbrec - To allow more information to be pass to an ETL::Pipeline::Output module

=head1 VERSION

This documentation refers to Dbrec version 1.00

=head1 SYNOPSIS

    use Dbrec;

    my $dbrec = Dbrec->new( dt => $dbh, mesg => 'dummy' );

=head1 DESCRIPTION

The 'output' method of ETL::Pipeline takes an anonmyous array of two items.
The first being the ETL::Pipeline::Output module you wish to use, the second
being what ever the programmer wishes. I wanted to be able to pass more
just in case so I created a Moose Object, Dbrec.

At the current time it is only receiving the database handle and bogus text
message.

=head1 ATTRIBUTES

=head2 mesg

Be able to pass back and forth a message from the ETL::Pipeline::Output
module

=cut

has 'mesg', is => 'rw', isa => 'Str';

=head2 dt

Database handle

=cut

has 'dt', is => 'rw', isa => 'Object';

=head1 SUBROUTINES/METHODS

=head2 BUILD

Is Moose method called after new() to perform additional tasks

=cut

sub BUILD {
    my $self = shift;
    return;
}

__PACKAGE__->meta->make_immutable;
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

__END__
