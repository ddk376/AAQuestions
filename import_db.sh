#!/usr/bin/env sh

dropdb sqlzoo
createdb sqlzoo
psql sqlzoo < import_db.sql
