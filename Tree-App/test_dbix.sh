#!/usr/bin/env bash
clear
source ../env.sh
export DBIC_TRACE=1
prove -I../Tree-DB/lib/ -I../Tree-DB-DBIx/lib/ -I./lib t
