#!/bin/bash
set -e

gem install bundler:2.1.4

# Ensure all gems installed.
bundle check || bundle install

bundle binstubs bundler --force

# Add binstubs to bin which has been added to PATH in Dockerfile.
bundle exec spring binstub --all

bin/yarn install --check-files

bin/rake db:create && bin/rake db:migrate || bin/rake db:setup
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
