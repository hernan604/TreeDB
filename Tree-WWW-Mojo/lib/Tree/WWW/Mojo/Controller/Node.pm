package Tree::WWW::Mojo::Controller::Node;
use base 'Mojolicious::Controller';
use DDP;

#adds one node to given parent_id
#accepts json request with parent_id 
sub add {
    my $self = shift;
    my $parent_id = $self->req->json->{ parent_id };
    my $parent = $self->tree->node->find( $parent_id );
    my $child = $parent->create_child;
    $self->respond_to(
        json => sub {
            my $self = shift;
            $self->render( json => { 
                node => $child->as_hash
            } );
        }
    );
}

#brings 1 node, based on id
sub get {
    my $self = shift;
    my $node = $self->tree->node->find( $self->param( 'id' ) );
    $self->respond_to(
        json => sub {
            my $self = shift;
            $self->render( json => { 
                node => $node->as_hash
            } );
        }
    );
}

1;
