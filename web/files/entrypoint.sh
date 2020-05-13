#!/bin/sh

# Exit on fail, see: http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_25
set -e

# TODO add content here

# Finish
echo "Container is ready !"

# Call original entrypoint
exec docker-php-entrypoint "$@"

# Launch CMD command (already done by original entrypoint)
# exec "$@"
