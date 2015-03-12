package Tree::App;
use strict;
use warnings;
use Moo;
use Tree::App::Node;
our $VERSION = 0.01;

has db => ( is => 'rw' );

has node => (
    is      => 'lazy',
    default => sub {
        my $self = shift;
        Tree::App::Node->new( _app => $self );
    }
);

sub cleanup {
    my $self = shift;

    #cleanup the db.. deletes everything :P
    $self->db->cleanup;
}

=head1 NAME

Tree::App - Tree application

=head1 SYNOPSIS

  use Tree::App;
  blah blah blah


=head1 DESCRIPTION

Stub documentation for this module was created by ExtUtils::ModuleMaker.
It looks like the author of the extension was negligent enough
to leave the stub unedited.

Blah blah blah.


=head1 USAGE



=head1 BUGS



=head1 SUPPORT



=head1 AUTHOR

    Hernan Lopes
    CPAN ID: HERNAN
    perldelux
    hernanlopes@gmail.com
    http://www.perldelux.com.br

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

perl(1).

=cut

#################### main pod documentation end ###################

1;

# The preceding line will help the module return a true value

