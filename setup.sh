#!/bin/bash

# gRPC Hello World Setup Script

echo "Setting up gRPC Hello World project..."

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "Error: Go is not installed. Please install Go first."
    exit 1
fi

# Check if protoc is installed
if ! command -v protoc &> /dev/null; then
    echo "Error: protoc is not installed. Installing..."
    
    # Detect OS and install protoc
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install protobuf
        else
            echo "Please install Homebrew first, then run: brew install protobuf"
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y protobuf-compiler
        elif command -v yum &> /dev/null; then
            sudo yum install -y protobuf-compiler
        else
            echo "Please install protobuf-compiler manually"
            exit 1
        fi
    else
        echo "Please install protoc manually from https://github.com/protocolbuffers/protobuf/releases"
        exit 1
    fi
fi

# Install Go protoc plugins
echo "Installing Go protoc plugins..."
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Create hello directory
echo "Creating hello directory..."
mkdir -p hello

# Generate Go code from proto
echo "Generating Go code from proto file..."
protoc --go_out=./hello --go_opt=paths=source_relative \
    --go-grpc_out=./hello --go-grpc_opt=paths=source_relative \
    hello.proto

# Install Go dependencies
echo "Installing Go dependencies..."
go mod tidy

echo "Setup complete!"
echo ""
echo "To run the application:"
echo "1. Start the server: go run server.go"
echo "2. In another terminal, run the client: go run client.go"
echo ""
echo "To test with grpcurl:"
echo "grpcurl -plaintext -d '{\"name\": \"World\"}' localhost:50051 hello.Greeter/SayHello"
