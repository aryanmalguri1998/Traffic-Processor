#!/bin/bash

# Function to check if Kafka is installed
is_kafka_installed() {
    if [[ -d "/opt/kafka" ]]; then
        return 0  # Kafka is installed
    else
        return 1  # Kafka is not installed
    fi
}

# Function to install Kafka
install_kafka() {
    echo "Installing Kafka..."

    # Download Kafka
    wget https://downloads.apache.org/kafka/3.6.1/kafka_2.13-3.6.1.tgz

    # Extract Kafka
    tar -xzf kafka_*.tgz
    
    rm kafka_*.tgz*

    # Move Kafka to desired location
    sudo mv kafka_* /opt/kafka

    echo "Kafka installed successfully."
}

# Check if Kafka is already installed
if is_kafka_installed; then
    echo "Kafka is already installed."
else
    install_kafka
fi

exit 0
