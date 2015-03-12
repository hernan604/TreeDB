use lib qw|
    Tree-DB/lib/
    Tree-DB-DBIx/lib/
|;
use Tree::DB;
use Tree::DB::DBIx;
my $db =
  Tree::DB->new( backend =>
      Tree::DB::DBIx->connect( $ENV{DB_DSN}, $ENV{DB_USER}, $ENV{DB_PASS} ) );
$db->backend->deploy;
