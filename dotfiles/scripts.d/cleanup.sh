#!/bin/bash

# Log output with timestamp
LOG_FILE="/var/log/docker-cleanup.log"
echo "=== Docker Cleanup: $(date) ===" | tee -a "$LOG_FILE"

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
  echo "Error: Docker is not running" | tee -a "$LOG_FILE"
  exit 1
fi

# Show disk usage before cleanup
echo "Disk usage before:" | tee -a "$LOG_FILE"
df -h / | tail -1 | tee -a "$LOG_FILE"

# Perform cleanup
echo "Running cleanup..." | tee -a "$LOG_FILE"
docker system prune -a -f --volumes 2>&1 | tee -a "$LOG_FILE"

# Show disk usage after cleanup
echo "Disk usage after:" | tee -a "$LOG_FILE"
df -h / | tail -1 | tee -a "$LOG_FILE"

echo "Cleanup complete" | tee -a "$LOG_FILE"
