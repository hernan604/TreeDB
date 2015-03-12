package Tree::DB::DBD::Node;
use Moo;

has _app => ( is => 'rw' );

sub create {
    my $self = shift;
    my $args = shift;
    warn "Tree::DB::DBI::Node CREATE";
    warn "Tree::DB::DBI::Node CREATE";
    warn "Tree::DB::DBI::Node CREATE";
#   $self->_app->backend->
    use DDP;
#   warn p $self->_app->backend->resultset('Node')->create($args);
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

sub cleanup {
    my $self = shift;
    warn "cleaning up Table Node.. deleting all rows...";
}

1;
