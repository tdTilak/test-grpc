# gRPC Hello World Makefile

.PHONY: all setup proto build run-server run-client test-grpcurl clean help

# Default target
all: setup build

# Setup the project
setup:
	@echo "Setting up gRPC Hello World project..."
	@mkdir -p hello
	@go mod tidy

# Generate protobuf code
proto:
	@echo "Generating Go code from proto file..."
	@protoc --go_out=./hello --go_opt=paths=source_relative \
		--go-grpc_out=./hello --go-grpc_opt=paths=source_relative \
		hello.proto

# Build the applications
build: proto
	@echo "Building server and client..."
	@go build -o bin/server server.go
	@go build -o bin/client client.go

# Run the server
run-server:
	@echo "Starting gRPC server on :50051..."
	@go run server.go

# Run the client
run-client:
	@echo "Running gRPC client..."
	@go run client.go

# Run client with custom name
run-client-name:
	@echo "Running gRPC client with name '$(NAME)'..."
	@go run client.go "$(NAME)"

# Test with grpcurl
test-grpcurl:
	@echo "Testing with grpcurl..."
	@echo "Listing services:"
	@grpcurl -plaintext localhost:50051 list
	@echo "\nCalling SayHello:"
	@grpcurl -plaintext -d '{"name": "World"}' localhost:50051 hello.Greeter/SayHello
	@echo "\nCalling SayHelloAgain:"
	@grpcurl -plaintext -d '{"name": "Alice"}' localhost:50051 hello.Greeter/SayHelloAgain

# Install dependencies
install-deps:
	@echo "Installing dependencies..."
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	@go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	@rm -rf hello/
	@rm -rf bin/
	@go clean

# Help target
help:
	@echo "Available targets:"
	@echo "  all          - Setup and build everything"
	@echo "  setup        - Initialize the project"
	@echo "  proto        - Generate Go code from proto file"
	@echo "  build        - Build server and client binaries"
	@echo "  run-server   - Start the gRPC server"
	@echo "  run-client   - Run the gRPC client"
	@echo "  run-client-name NAME=<name> - Run client with custom name"
	@echo "  test-grpcurl - Test server with grpcurl"
	@echo "  install-deps - Install Go protoc plugins"
	@echo "  clean        - Remove generated files"
	@echo "  help         - Show this help message"
	@echo ""
	@echo "Example usage:"
	@echo "  make setup"
	@echo "  make run-server &"
	@echo "  make run-client"
	@echo "  make run-client-name NAME=Bob"
	@echo "  make test-grpcurl"
