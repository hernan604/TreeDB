package Tree::WWW::Mojo::Controller::Tree;
use base 'Mojolicious::Controller';
use DDP;

sub get {
    my $self = shift;
    my $reference_node = ( $self->param('id') )
        ? $self->tree->node->find( $self->param('id') )
        : $self->tree->node->root
        ;
    my $tree = $reference_node->tree_as_hash;
    $self->respond_to(
        json => sub {
            my $self = shift;
            $self->render( json => {
                tree => $tree
            } );
        }
    );
}

1;
