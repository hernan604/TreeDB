# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 2;

BEGIN { use_ok( 'Tree::App' ); }

my $object = Tree::App->new ();
isa_ok ($object, 'Tree::App');


