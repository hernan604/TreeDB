source ../env.sh
dbicdump -o dump_directory=./lib \
-o debug=1 \
Tree::DB::DBIx \
$DB_DSN \
$DB_USER \
$DB_PASS
