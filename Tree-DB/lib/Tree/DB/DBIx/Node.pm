package Tree::DB::DBIx::Node;
use Moo;

has _app => ( is => 'rw' );

sub create {
    my $self = shift;
    my $args = shift;
    $self
        ->_app
        ->backend
        ->resultset('Node')
        ->create_node($args);
}

sub count {
    my $self      = shift;
    my $condition = shift;
}

sub list {
    my $self      = shift;
    my $condition = shift;
}

sub delete {
    my $self = shift;
    my $id   = shift;
}

sub update {
    my $self   = shift;
    my $id     = shift;
    my $values = shift;
}

sub search {
    my $self = shift;
    my $args = shift;
    my @results = $self
        ->_app
        ->backend
        ->resultset('Node')
        ->search( $args )
        ->all
        ;
    [
        map {
            $_->{ _column_data }
        } @results
    ];
}

sub find {
    my $self = shift;
    my $id = shift;
    my $item = $self
        ->_app
        ->backend
        ->resultset('Node')
        ->find($id)
        ;
    $item->{_column_data};
}

sub cleanup {
    #deletes every record from table Node
    my $self = shift;
    $self
        ->_app
        ->backend
        ->resultset('Node')
        ->search()
        ->delete
        ;
}

1;
