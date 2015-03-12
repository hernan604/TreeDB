#ABSTRACT: represents a node
package Tree::App::Node;
use Moo;
use DDP;
has id          => ( is => 'rw' );
has _parent      => ( is => 'rw' );
#has parent      => ( is => 'rw' ); #ref to parent node. for root this is undef
has parent_id   => ( is => 'rw' );
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
    $self->new_node( $node_info );
}

#creates child nodes for this class
sub create_child {
    my $self = shift;
    my $child_info = $self->_app->db->node->create( { parent_id => $self->id } );
   #use DDP;
   #warn p $child_info;
    my $child = $self->new_node( $child_info );
    $child->_parent( $self );
    $child;
}

sub parent {
    my $self = shift;
    return $self->_parent if $self->_parent;
    if ( defined $self->parent_id and ! $self->_parent ) {
        my $parent = $self->find( $self->parent_id );
        $self->_parent( $parent );
        return $self->_parent;
    }
    return undef;
}

sub children {
    my $self = shift;
    my $children = $self->_app->db->node->search( { parent_id => $self->id } );
    [
        map {
            my $child = Tree::App::Node->new( $_ );
            $child->_app( $self->_app );
            $child->_parent( $self );
            $child;
        } @{ $children }
    ]
}

sub find {
    #searches based on id
    my $self = shift;
    my $id = shift;
    my $item = $self->_app->db->node->find( $id );
    $self->new_node( $item );
}

sub root {
    my $self = shift;
    my $values = $self->_app->db->node->find({parent_id => undef});
    $self->new_node( $values );
}

sub new_node {
    my $self = shift;
    my $values = shift;
    my $node = Tree::App::Node->new( $values );
    $node->_app( $self->_app );
    $node;
}

sub tree {
    #builds a complete tree for this node that contains all its children and childrens children
    my $self = shift; 
    my $args = shift; #ie. { level => 1 }
       $args = $args || { level => 0 }; #from perspective of this node
    my $childs = $self->children;
    my $next_level = ( $args->{ level } + 1 );
    my $next_level_args = {%$args};
    $next_level_args->{level} = $args->{ level } + 1;
    return {
        node     => ( ( $args->{ as_hash } ) ? $self->as_hash : $self ),
        level    => $args->{ level },
        children => [map { $_->tree( $next_level_args ) } @$childs]
    };
};

sub as_hash {
    my $self = shift;
    return {
        id          => $self->id,
        parent_id   => $self->parent_id
    };
}

sub tree_as_hash {
    my $self = shift;
    my $args = shift;
    $args = $args || { level => 0 };
    $args->{ as_hash } = 1;
    my $tree = $self->tree( $args );
    
}

1;
