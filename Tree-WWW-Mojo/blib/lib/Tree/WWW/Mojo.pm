package Tree::WWW::Mojo;
use Mojo::Base 'Mojolicious';

our $VERSION = 0.01;

sub startup {
    my $self = shift;
    my $config = $self->plugin( 'Config' => { file => 'myconfig.pl' } );

    my $r = $self->routes;
    $r->namespaces(['Tree::WWW::Mojo::Controller']);

    $self->helper( tree => sub { $config->{ tree } } );
}


1;
