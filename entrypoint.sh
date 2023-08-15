#!/bin/bash
set -e

rm -f /search-word-app/tmp/pids/server.pid

# MySQLが起動するのを待つ
until mysqladmin ping -h"db" -P"3306" --silent; do
  echo "Waiting for MySQL to be up..."
  sleep 2
done



# 本番 createとseedはfargateの初回のみ実行
bundle exec rails db:create
bundle exec rails db:migrate
# bundle exec rails db:seed

exec "$@"