package Tree::DB::DBIx::ResultSet::Node;
use base 'DBIx::Class::ResultSet';
use DDP;
use Carp;

#   sub cleanup {
#       my $self = shift;
#       $self->result_source->schema->storage->dbh_do(sub {
#           my ( $storage, $dbh, @cols ) = @_;
#   #       $dbh->selectrow_array( "delete from Node where 1=1" );
#           my $sth = $dbh->prepare( "delete from Node where 1=1" );
#           $sth->execute( );
#       });
#   #   $self->sc
#   #   my @tesults = $self->search()->all;
#   #   use DDP; warn p @results;
#   }
#

sub create_node {
    my $self = shift;
    my $args = shift;
    if ( $args && $args->{ parent_id } ) {
        #user wants to create a child..
        my $child = $self->create( $args );
        return $child->{_column_data};
    } else {
        #user wants to create a root node... if a root node exists, return it. dont create a second root node
        if ( $self->search({})->count == 0 ) {
            my $root = $self->create( $args );
            return $root->{_column_data};
        } else {
            carp "ERROR: not allowed to create two root nodes";
        }
    }
}


sub list_all {
    my $self = shift;
    print "LIST_ALL\n";
    my $rows = $self->_select_all;
#   $self->sc
#   my @tesults = $self->search()->all;
#   use DDP; warn p @results;
}

sub _count {
    my $self = shift;
    $self->result_source->schema->storage->dbh_do(sub {
       #my ( $storage, $dbh, @cols ) = @_;
        my ( $storage, $dbh ) = @_;
#       $dbh->selectrow_array( "delete from Node where 1=1" );
#       use DDP;
#       my $rv  = $dbh->do( "select id, parent_id from Node", {}, ());
#       warn p $rv;
#       my $sth  = $dbh->prepare("select id, parent_id from Node where 1=1");
        my $rows  = $dbh->selectall_arrayref('select count(*) as total from Node');
        return $rows->[0];

#       my $sth = $dbh->prepare( "select id, parent_id from Node" );
#       $sth->execute;

#       use DDP;
#       warn "ROWS:". $sth->rows;
#       while ( my @data = $sth->fetchrow_array() ) {
#           warn p $data;
#       }
#       $sth->finish;
#       warn p @data;
    });
}

#   sub create_node {
#       my $self = shift;
#       my $id = shift;
#       my $node = shift;

#       return undef if ( $self->_count == 0 and ! defined $id );
#   #   return undef if ( scalar @$rows == 0 );
#       $self->result_source->schema->storage->dbh_do( sub {
#          #my ( $storage, $dbh, @cols ) = @_;
#           my ( $storage, $dbh ) = @_;
#   #       $dbh->selectrow_array( "delete from Node where 1=1" );
#           my $sth = $dbh->prepare( "insert into Node (parent_id) values (?); " );
#   #select last_insert_id();
#           my $res = $sth->execute( defined $id ? $id : undef );

#           use DDP;
#           warn p $sth;
#           warn p $res;
#           $sth->finish;
#       } );
#   }

1;
