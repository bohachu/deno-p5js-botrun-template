#!/bin/bash

# Kill any process using port 8080
echo "Checking for processes on port 8080..."
if lsof -ti:8080 > /dev/null 2>&1; then
    echo "Killing process on port 8080..."
    lsof -ti:8080 | xargs kill -9
    echo "Process killed."
else
    echo "No process found on port 8080."
fi

# Wait a moment for the port to be released
sleep 1

# Run the Deno server
echo "Starting Deno server on 0.0.0.0:8080..."
deno run --allow-net --allow-read src/server.ts