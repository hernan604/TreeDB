package Tree::DB;
use strict;
use warnings;
use Moo;
use Carp;

has backend => ( is => 'rw', trigger => \&set_backend_layer );
has node    => ( is => 'rwp' );

sub set_backend_layer {
    my $self = shift;
    if ( $self->backend->isa('DBIx::Class::Schema') ) {
        $self->load_dbix_layer;
    } elsif ( $self->backend->isa( 'DBD::mysql' )) {
        $self->load_dbd_layer;
    } else {
        croak "DB backend not implemented";
    }
}

sub load_dbix_layer {
    #uses a layer that talks to DBIx
    my $self = shift;
    require Tree::DB::DBIx::Node;
    $self->_set_node( Tree::DB::DBIx::Node->new( _app => $self ) );
}

sub load_dbd_layer {
    #uses a layer that talks to DBD
    my $self = shift;
    require Tree::DB::DBD::Node;
    $self->_set_node( Tree::DB::DBD::Node->new( _app => $self ) );
}

sub cleanup {
    my $self = shift;
    #delete everything from the tables
    $self->node->cleanup;
}

#   sub BUILD {
#       my $self = shift;
#       warn "check if backend is DBIx or DBI";
#       use DDP;
#       warn $self->backend->isa('DBIx::Class::Schema');
#       warn $self->backend->isa('DBIx::Class::Schema');
#       warn $self->backend->isa('DBIx::Class::Schema');
#       warn p $self->backend;
#       warn ref $self->backend;
#       warn ref $self->backend;
#       warn ref $self->backend;
#   }

#   =head3 cleanup
#   Cleanup the database. Deletes all the rows and values.
#   =cut

#   sub cleanup {
#       my $self = shift;
#   #   $self->result_source->schema->storage->dbh_do(sub {
#       $self->storage->dbh_do(sub {
#          #my ( $storage, $dbh, @cols ) = @_;
#           my ( $storage, $dbh ) = @_;
#           my @querys = ("delete from Node where 1=1");
#           for ( @querys ) {
#               my $sth = $dbh->prepare( $_ );
#               $sth->execute();
#           }
#       });
#   }

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
