#!/usr/bin/env bash
source ../env.sh
export MOJO_LISTEN="http://*:3000"
export DBIC_TRACE=1
perl -I../Tree-App/lib/ -I../Tree-DB/lib/ -I../Tree-DB-DBIx/lib/ -I../Tree-DB-DBD/lib/ -I./lib myapp.pl
