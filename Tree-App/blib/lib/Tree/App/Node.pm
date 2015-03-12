#ABSTRACT: represents a node
package Tree::App::Node;
use Moo;
use DDP;
has id          => ( is => 'rw' );
has parent      => ( is => 'rw' ); #ref to parent node. for root this is undef
has parent_id   => ( is => 'rw', trigger => \&_set_parent_instance ); #ref to parent node. for root this is undef
has _app        => ( is => 'rw' ); #ref to app

#returns an array of nodes
sub all {
    my $self = shift;
    $self->_app->schema->resultset('Node')->list_all;
}

#creates the root node
sub create_root {
    my $self = shift;
    warn "creating root....";
    my $node_info = $self->_app->db->node->create({});
    my $node = Tree::App::Node->new( $node_info );
    $node->_app( $self->_app );
    $node;
}

#creates child nodes for this class
sub create_child {
    my $self = shift;
    my $child_info = $self->_app->db->node->create( { parent_id => $self->id } );
   #use DDP;
   #warn p $child_info;
    my $child = Tree::App::Node->new( $child_info );
    $child->_app( $self->_app );
    $child->parent( $self );
    $child;
}

sub children {
    my $self = shift;
    my $children = $self->_app->db->node->search( { parent_id => $self->id } );
    [
        map {
            my $child = Tree::App::Node->new( $_ );
            $child->_app( $self->_app );
            $child->parent( $self );
            $child;
        } @{ $children }
    ]
}

sub find {
    #searches based on id
    my $self = shift;
    my $id = shift;
    my $item = $self->_app->db->node->find( $id );
    my $node = Tree::App::Node->new( $item );
    $node->_app( $self->_app );
    $node->parent( $self->find( $item->{ parent_id } ) ) if $item->{ parent_id };
    $node;
}

sub _set_parent_instance {
    my $self = shift;
#   warn "buscando parent";
#   if ( !$self->parent->isa( 'Tree::App::Node' ) ) {
#       $self->parent( $self->find( $self->parent_id ) );
#   }
}

1;
