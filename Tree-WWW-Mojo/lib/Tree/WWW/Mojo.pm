package Tree::WWW::Mojo;
use Mojo::Base 'Mojolicious';

our $VERSION = 0.01;

sub startup {
    my $self = shift;
    my $config = $self->plugin( 'Config' => { file => 'myconfig.pl' } );

    my $r = $self->routes;
    $r->namespaces(['Tree::WWW::Mojo::Controller']);

    $self->helper( tree => sub { $config->{ tree } } );
    $self->tree->cleanup;

    $r->route('/')
        ->name('home')
        ->to(controller => 'Home', action => 'index');

    $r->route('/endpoint/tree')
        ->name('tree')
        ->to(controller => 'Tree', action => 'get');

    $r->route('/endpoint/tree/:id')
        ->name('tree_id')
        ->to(controller => 'Tree', action => 'get');

    $r->route('/endpoint/node/add')
        ->name('node_add')
        ->to(controller => 'Node', action => 'add');

    $r->route('/endpoint/node/get/:id')
        ->name('node_get')
        ->to(controller => 'Node', action => 'get');

}


1;
