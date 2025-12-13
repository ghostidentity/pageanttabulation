#!/bin/bash

echo "=== Killing NATS servers on port 4222 ==="
lsof -ti :4222 | xargs -r kill -9
pkill -9 -f nats-server
pkill -9 -f "target.*Pageant"
lsof -i :4222 || echo "Port 4222 is now free"

echo ""
echo "✓ Server Terminated"
