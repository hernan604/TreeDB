#!/usr/bin/env bash
source ./env.sh
echo $DB_DSN
perl deploy.pl
