#!/bin/bash

# Define the port number to listen on
PORT=8080

# Function to handle incoming requests
handle_request() {
    while IFS= read -r line; do
        if [ -z "$line" ]; then
            break
        fi
        echo "$line"
    done
}

# Main function to start the server
start_server() {
    echo "Server listening on port $PORT..."
    while true; do
        # Accept incoming connections and handle requests
        { echo -ne "HTTP/1.1 200 OK\r\nContent-Length: 12\r\n\r\nHello World!"; } | nc -l -p "$PORT" | handle_request
    done
}

# Start the server
start_server
