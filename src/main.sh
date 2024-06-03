#!/bin/bash

source "../configs/kafka.cfg"

LOG_FILE="../logs/traffic.log"

SERVER_HOST="localhost"
SERVER_PORT=8080

# Function to log request
log_request() {
    local method="$1"
    local url="$2"
    local headers="$3"
    local payload="$4"
    local ip="$5"

    # Log request details
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Request: $method $url" >> "$LOG_FILE"
    echo "Headers: $headers" >> "$LOG_FILE"
    echo "Payload: $payload" >> "$LOG_FILE"
    echo "IP Address: $ip" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"

    # Send request details to Kafka
    send_to_kafka "{\"type\":\"request\", \"method\":\"$method\", \"url\":\"$url\", \"headers\":\"$headers\", \"payload\":\"$payload\", \"ip\":\"$ip\"}"
}

# Function to log response
log_response() {
    local status_code="$1"
    local headers="$2"
    local payload="$3"

    # Log response details
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Response: $status_code" >> "$LOG_FILE"
    echo "Headers: $headers" >> "$LOG_FILE"
    echo "Payload: $payload" >> "$LOG_FILE"
    echo "------------------------------------------------------------" >> "$LOG_FILE"

    # Send response details to Kafka
    send_to_kafka "{\"type\":\"response\", \"status_code\":\"$status_code\", \"headers\":\"$headers\", \"payload\":\"$payload\"}"
}

# Function to send data to Kafka
send_to_kafka() {
    local message="$1"

    # Ensure Kafka producer script exists
    if [ ! -f "$KAFKA_PRODUCER_SCRIPT" ]; then
        echo "Error: Kafka producer script '$KAFKA_PRODUCER_SCRIPT' not found." >&2
        exit 1
    fi

    # Send message to Kafka
    echo "$message" | "$KAFKA_PRODUCER_SCRIPT" --broker-list "$KAFKA_BROKERS" --topic "$KAFKA_TOPIC" || {
        echo "Error: Failed to send data to Kafka." >&2
        exit 1
    }
}

# Ensure script exits immediately if any command fails
set -e

# Ensure Kafka broker details are provided
if [ -z "$KAFKA_BROKERS" ]; then
    echo "Error: Kafka broker details are not provided." >&2
    exit 1
fi

# Example usage
log_request "GET" "http://$SERVER_HOST:$SERVER_PORT/api" "Content-Type: application/json" '{"key": "value"}' "192.168.1.1"
response=$(curl -s -X GET "http://$SERVER_HOST:$SERVER_PORT/api" -H "Content-Type: application/json" -d '{"key": "value"}') || {
    echo "Error: Failed to connect to the API server." >> "$LOG_FILE"
    echo "------------------------------------------------------------" >> "$LOG_FILE"
    exit 1
}
log_response "200 OK" "Content-Type: application/json" "$response"
