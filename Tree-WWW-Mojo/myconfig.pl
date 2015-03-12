use strict;
use warnings;
use Tree::App;
use Tree::DB;
use Tree::DB::DBIx;
use DDP;
my $db =
  Tree::DB->new( backend =>
      Tree::DB::DBIx->connect( $ENV{DB_DSN}, $ENV{DB_USER}, $ENV{DB_PASS} ) );
my $tree = Tree::App->new( db => $db );

#Here is the config for app
{
    tree => $tree,
}

