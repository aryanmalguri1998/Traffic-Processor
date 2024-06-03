#!/bin/bash

# Function to check if Kafka is running
is_kafka_running() {
    # Check if Kafka server process is running
    if pgrep -x "java" | grep "kafka.Kafka"; then
        return 0  # Kafka is running
    else
        return 1  # Kafka is not running
    fi
}

# Function to start Kafka
start_kafka() {
    echo "Starting Kafka..."

    # Change directory to Kafka installation directory
    cd /opt/kafka

    {
        # Stop Zookeeper and Kafka server if already running
        bin/zookeeper-server-stop.sh config/zookeeper.properties;
        bin/kafka-server-stop.sh config/server.properties;
    }

    bin/zookeeper-server-start.sh config/zookeeper.properties & sleep 3 && bin/kafka-server-start.sh config/server.properties &

    echo "Kafka started successfully."
}

# Check if Kafka is already running
if is_kafka_running; then
    echo "Kafka is already running."
else
    start_kafka
fi

exit 0
