#!/bin/bash
set -e

docker-compose down

echo "Removing old configuration..."
rm -rf *.env
rm -rf .credentials*
rm -rf docker-compose.yml
rm temp-*.json
rm .*_id
