package Up::Controller::Upload;
use Mojo::Base 'Mojolicious::Controller';
use strict;
use warnings;
use utf8::all;
use feature qw(say);
use feature qw(signatures);
no warnings qw(experimental::signatures);    ## no critic
use lib 'lib';
use Carp 'croak';
use English;
use Try::Tiny;
use Ouch;
use Up::Model::Displaytable;
use Up::Model::Etlpipeline;
use Data::Dumper;

our $VERSION = '1.00';
our @Dataset;

sub menu {
    my $self = shift;
    $self->render(
        message  => 'Menu',
        template => 'upload/menu',
        format   => 'html',
        handler  => 'ep'
    );
    return;
}

# They just were shown templates/upload/menu.html.tt
# What choice did they make
sub MenuChose {
    my $self = shift;

    # Check CSRF token
    my $v = $self->validation;
    return $self->render( text => 'Bad CSRF token!', status => 403 )
        if $v->csrf_protect->has_error('csrf_token');

    # find out what was selected and redirect them
    if ( !defined $self->param('select') ) {

        # you didn't choose an option
        $self->redirect_to('/uploadmenu');
    }
    elsif ( $self->param('select') eq 'file_upload' ) {
        $self->redirect_to('FileUpload');
    }
    elsif ( $self->param('select') eq 'biglist' ) {
        $self->redirect_to('biglist');
    }
    else {
        $self->redirect_to('/uploadmenu');
    }
    return;
}

sub FileUpload {
    my $self = shift;
    $self->render(
        message  => 'Menu',
        template => 'upload/fileupload',
        format   => 'html',
        handler  => 'ep'
    );
    return;
}

sub ProcessFiles {
    my $self = shift;

    # Check CSRF token
    my $v = $self->validation;
    return $self->render( text => 'Bad CSRF token!', status => 403 )
        if $v->csrf_protect->has_error('csrf_token');

    my $f = $self->req->every_upload('files');
    my @files;
    for my $file ( @{$f} ) {
        my $name = $file->filename;

        push @files, {name => $file->filename, size => $file->size};

        eval {
            # this is really a copy, don't ask me why?!
            $file->move_to( './uploaded/' . $name );

            Up::Model::Etlpipeline::perform( $name, $self->db );
            1;
        } or do {
            if ( hug($EVAL_ERROR) ) {
                $self->render( text => bleep($EVAL_ERROR) );
#               $self->render( text => $EVAL_ERROR->message );
            }
            else {
                $self->render( text => "$EVAL_ERROR" );
            }
            return;
        };
    }

    #   $self->render(text => "@files");
    $self->render(
        files    => \@files,
        template => 'upload/displayupload',
        format   => 'html',
        handler  => 'ep',
    );

    return;
}

sub biglist {
    my $self = shift;

    ### Not need because it is redirected here from MenuChose which
    ### did the checking
    # Check CSRF token
    #my $v = $self->validation;
    #return $self->render( text => 'Bad CSRF token!', status => 403 )
    #    if $v->csrf_protect->has_error('csrf_token');

    my $guard;
    try {
        $guard   = $self->db->txn_scope_guard;                  # BEGIN_TRANSACTION
        @Dataset = ();
        @Dataset = $self->db->resultset('Dataset')->search();

        my @dataset_2display;
        for my $d (@Dataset) {

#         my $str = sprintf "File: %20.20s Date: %s", $d->file, $d->transaction_date;
## no critic
            my $str = sprintf "Date: %20.20s ___File: %s",
                $d->transaction_date, $d->file;
## use critic
            push @dataset_2display, {file_id => $d->file_id, desc => $str};
        }
        $self->render(
            size     => ( scalar @Dataset ),
            dataset  => \@dataset_2display,
            template => 'upload/biglist',
            format   => 'html',
            handler  => 'ep',
        );
    }
    catch {
        $self->render( text => "Error: $_" );
        return;
    };
    $guard->commit;    # END_TRANSACTION
    return;
}

# They just were shown template/upload/list.html.tt
# What choice did they make
sub ViewChose {
    my $self = shift;
    return;
}

sub displaydataset {
    my $self = shift;

    # if nothing was selected, send them back
    if ( not defined( $self->param('listname') ) ) {
        $self->redirect_to('biglist');
        return;
    }

    my $file_id = $self->param('listname');
    my $filen;
    for my $d (@Dataset) {
        if ( $d->file_id == $file_id ) {
            $filen = $d->file;
            last;
        }
    }
    my $txt = Up::Model::Displaytable::perform( $file_id, $self->db );
    $self->render(
        filen    => $filen,
        txt      => $txt,
        template => 'upload/displaydataset',
        format   => 'html',
        handler  => 'ep',
    );
    return;
}
1;

=head1 NAME

Up::Controller::Upload - A Mojolicious controller for the Upload Menu System.

=head1 VERSION

This documentation refers to Upload version 1.00

=head1 SYNOPSIS

The Mojolicious default 'startup' method defines the routes that are
available to the web application. If a route definition, it declares
what controller and it's method that will handle the current event.
The methods in the 'Upload' controller handle all the events for
the Upload Files Menu system.

=head1 DESCRIPTION

This modules contains the Controller methods of the Upload Menu System.
Some methods will call Business logic methods in the Model library of 
the System.
Say it with me. "Small Controllers, Fat Models in MVC"

=head1 SUBROUTINES/METHODS

=head2 menu

Display the Upload Main Menu of 1) Upload files 2) View files uploaded

=head2 MenuChose

Find out what menu option was chosen and send them on their way

=head2 FileUpload

Show the user the 'Browse' the file system button and the 'Upload button

=head2 ProcessFiles

The file(s) have been selected. Call the ETL model to process the list.
Then display the list of files processed.

=head2 biglist

Display a list of file(s) and their time stamps for the user to
chose one to display after the ETL process has happened.

=head2 ViewChose

They just were shown list of file(s) to view. What choice did they make?

=head2 displaydataset

Display the data inserted into the database in a html table.

=head1 DIAGNOSTICS

=head2 Possible Errors

Database errors.

Attributes missing from input files but are in the database table

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

=head1 LICENSE AND COPYRIGHT

Since this a proof of concept there is no license or copyright.

Help other Perl programmers out by posting full examples
of your hard testing/work to a github like repository.

