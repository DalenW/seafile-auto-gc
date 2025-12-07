#!/bin/bash
set -e

# Start cron service
service cron start

# Execute the original entrypoint/command
exec "$@"

