use Test::More;
use Tree::App;
use Tree::DB;
use Tree::DB::DBIx;
use strict;
use warnings;
use DDP;

my $db =
  Tree::DB->new( backend =>
      Tree::DB::DBIx->connect( $ENV{DB_DSN}, $ENV{DB_USER}, $ENV{DB_PASS} ) );
my $app = Tree::App->new( db => $db );

#cleanup
$app->cleanup;

#list nodes #must come nothing
#my $nodes = $app->node->all;
#create root node
my $root_node = $app->node->root;    #without id.. will be root
ok( defined $root_node,     '' );
ok( defined $root_node->id, '' );
like( $root_node->id, qr|^(\d+)$|, '' );

#list nodes #must come root node
###my $nodes = $app->node->all;
#create children
#$app->node->create( parent => 1);

my $root_child1;
{
    #CREATE A CHILD
    $root_child1 = $root_node->create_child;
    ok( defined $root_child1,     '' );
    ok( defined $root_child1->id, '' );
    like( $root_child1->id, qr|^(\d+)$|, '' );
    is( $root_child1->parent->id, $root_node->id, '' );
}

my $root_child2;
{
    #CREATE ANOTHER CHILD
    $root_child2 = $root_node->create_child;
    ok( defined $root_child2,     '' );
    ok( defined $root_child2->id, '' );
    like( $root_child2->id, qr|^(\d+)$|, '' );
    is( $root_child2->parent->id, $root_node->id, '' );
}

my $sub_child;
{
    #CREATE CHILD CHILD
    $sub_child = $root_child2->create_child;
    ok( defined $sub_child,     '' );
    ok( defined $sub_child->id, '' );
    like( $sub_child->id, qr|^(\d+)$|, '' );
    is( $sub_child->parent->id, $root_child2->id, '' );
    is( $sub_child->parent->parent->id, $root_node->id );
}

{
    #query for root childs
    my $children = $root_node->children;
    ok( scalar @$children == 2, '' );
    my $child1 = $children->[0];
    my $child2 = $children->[1];
    ok( $child1->parent->id == $root_node->id , '' );
    ok( $child2->parent->id == $root_node->id , '' );
}

{
    my $some_node = $app->node->find( $root_node->id );
    ok( $some_node->id == $root_node->id, '' );

    my $children = $some_node->children;
    ok( scalar @$children == 2, '' );
    my $child1 = $children->[0];
    my $child2 = $children->[1];
    ok( $child1->parent->id == $some_node->id , '' );
    ok( $child2->parent->id == $some_node->id , '' );
}

{
    my $root = $app->node->root;
    ok( $root->id == $root_node->id , '' );
    #find the complete tree

    my $tree = $root->tree;

    my $level_0_nodes = $tree;
    ok( $level_0_nodes->{level} == 0, '' );
    ok( $level_0_nodes->{node}->id == $root_node->id, '' );

    my @level_0_children = @{ $level_0_nodes->{children} };
#warn p @level_0_children;
    my $level_1_nodes = [ sort { $a->{node}->id <=> $b->{node}->id } map { $_ } @level_0_children ];

    ok( $level_1_nodes->[0]->{node}->id eq $root_child1->id , '' );
    ok( $level_1_nodes->[0]->{level} == 1 , '' );

    ok( $level_1_nodes->[1]->{node}->id eq $root_child2->id, '' );
    ok( $level_1_nodes->[1]->{level} == 1 , '' );

    ok( $level_1_nodes->[1]->{children}->[0]->{node}->id eq $sub_child->id , '' );
    ok( $level_1_nodes->[1]->{children}->[0]->{level} == 2 , '' );
}

{
    my $root = $app->node->root;
    my $tree_as_hash = $root->tree_as_hash;
    ok( scalar @{ $tree_as_hash->{children}} == 2, '' );
    ok( scalar @{ $tree_as_hash->{children}->[1]->{children}} == 1, '' );
    ok( $tree_as_hash->{children}->[1]->{children}->[0]->{level} == 2, '' );
#   warn p $tree_as_hash;
#   {
#       children   [
#           [0] {
#               children   [],
#               level      1,
#               node       {
#                   id          302,
#                   parent_id   301
#               }
#           },
#           [1] {
#               children   [
#                   [0] {
#                       children   [],
#                       level      2,
#                       node       {
#                           id          304,
#                           parent_id   303
#                       }
#                   }
#               ],
#               level      1,
#               node       {
#                   id          303,
#                   parent_id   301
#               }
#           }
#       ],
#       level      0,
#       node       {
#           id          301,
#           parent_id   undef
#       }
#   }
}

done_testing;

