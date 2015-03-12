use strict;
use warnings;
use Test::More;
use Test::Mojo;
use DDP;
use Mojo::URL;

use Test::More;
use Tree::App;
use Tree::DB;
use Tree::DB::DBIx;

my $db =
  Tree::DB->new( backend =>
      Tree::DB::DBIx->connect( $ENV{DB_DSN}, $ENV{DB_USER}, $ENV{DB_PASS} ) );
my $app = Tree::App->new( db => $db );

#cleanup
$app->cleanup;

my $root_node = $app->node->create_root; 

my $t     = Test::Mojo->new('Tree::WWW::Mojo');

$t->get_ok( '/endpoint/tree' => { 
        Accept => 'application/json'
    } )
    ->json_has('/tree')
    ->json_has('/tree/level')
    ->json_has('/tree/children')
    ->json_has('/tree/node')
    ->json_has('/tree/node/id')
    ->json_has('/tree/node/parent_id')
    ;

#test to add a node to root
my $r1 = $t->put_ok( '/endpoint/node/add' => {
        DNT     => 1,
        Accept => 'application/json'
    },
    json => {
        parent_id => $root_node->id
    } 
)
    ->json_has('/node/id')
    ->json_has('/node/parent_id')
    ;
my $child1 = $app->node->find( $r1->tx->res->json->{node}->{id} );


#adds another child to root
my $r2 = $t->put_ok( '/endpoint/node/add' => {
        DNT     => 1,
        Accept => 'application/json'
    },
    json => {
        parent_id => $root_node->id
    } 
)
    ->json_has('/node/id')
    ->json_has('/node/parent_id')
    ;
my $child2 = $app->node->find( $r2->tx->res->json->{node}->{id} );

#adds another child to roots child
my $r3 = $t->put_ok( '/endpoint/node/add' => {
        DNT     => 1,
        Accept => 'application/json'
    },
    json => {
        parent_id => $child2->id
    } 
)
    ->json_has('/node/id')
    ->json_has('/node/parent_id')
    ;
my $child2_child = $app->node->find( $r3->tx->res->json->{node}->{id} );

#test to get a node
my $r = $t->get_ok( '/endpoint/node/get/'.$root_node->id => {
        DNT     => 1,
        Accept => 'application/json'
    },
    json => {
        id => $root_node->id
    } 
)
    ->json_has('/node/id')
    ->json_has('/node/parent_id')
    ->json_is('/node/id', $root_node->id)
    ;

#now bring the updated tree and check if has 1 child
my $rr = $t->get_ok( '/endpoint/tree/'.$child2->{id} =>{
        Accept => 'application/json'
    })
    ->json_has('/tree')
    ->json_has('/tree/children')
;

ok( scalar @{$rr->tx->res->json->{tree}->{children}} ==1, 'has 1 child' );

done_testing();

