package Tree::WWW::Mojo::Controller::Home;
use base 'Mojolicious::Controller';

sub index {
    my $self = shift;
    $self->render( 'index' );
}

1;
