# gRPC Hello World

A simple gRPC Hello World implementation in Go with client, server, and grpcurl examples.

## Features

- Protocol Buffer service definition
- gRPC server implementation with reflection enabled
- gRPC client implementation
- grpcurl command examples for testing
- Complete setup and build instructions
- Fixed Go module structure to avoid common import issues

## Prerequisites

- Go 1.21 or later
- Protocol Buffer compiler (protoc)
- gRPC Go plugins
- grpcurl (for testing)

## Quick Setup

### 1. Clone and Setup

```bash
# Clone the repository
git clone https://github.com/tdTilak/test-grpc.git
cd test-grpc

# Install dependencies (this will create go.sum if needed)
go mod download
go mod tidy
```

### 2. Install Required Tools

```bash
# Install protoc compiler
# On macOS:
brew install protobuf

# On Ubuntu/Debian:
sudo apt install -y protobuf-compiler

# Install Go plugins
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Install grpcurl
# On macOS:
brew install grpcurl

# On Ubuntu/Debian:
sudo apt install grpcurl
```

### 3. Generate Go Code from Proto

```bash
# Create hello directory and generate code
mkdir -p hello
protoc --go_out=./hello --go_opt=paths=source_relative \
    --go-grpc_out=./hello --go-grpc_opt=paths=source_relative \
    hello.proto
```

## Running the Application

### Start the Server

```bash
go run server.go
```

The server will start listening on `localhost:50051`.

### Run the Client

In another terminal:

```bash
# Run with default name "world"
go run client.go

# Run with custom name
go run client.go "Alice"
```

## Testing with grpcurl

Once the server is running, you can test it using grpcurl:

### List Available Services

```bash
grpcurl -plaintext localhost:50051 list
```

### Describe the Service

```bash
grpcurl -plaintext localhost:50051 describe hello.Greeter
```

### Call SayHello Method

```bash
grpcurl -plaintext -d '{"name": "World"}' localhost:50051 hello.Greeter/SayHello
```

### Call SayHelloAgain Method

```bash
grpcurl -plaintext -d '{"name": "Alice"}' localhost:50051 hello.Greeter/SayHelloAgain
```

### More Examples

```bash
# Test with different names
grpcurl -plaintext -d '{"name": "Bob"}' localhost:50051 hello.Greeter/SayHello
grpcurl -plaintext -d '{"name": "Charlie"}' localhost:50051 hello.Greeter/SayHelloAgain

# Using proto file directly (alternative method)
grpcurl -plaintext -proto hello.proto -d '{"name": "DirectProto"}' localhost:50051 hello.Greeter/SayHello
```

## Troubleshooting

### Common Issues and Solutions

#### 1. Relative Import Error
**Error:** `"./hello" is relative, but relative import paths are not supported in module mode`

**Solution:** This has been fixed in the current version. The import paths now use the module path:
```go
import pb "grpc-hello-world/hello"
```

#### 2. Missing go.sum Entry
**Error:** `missing go.sum entry for module providing package google.golang.org/grpc`

**Solution:** Run these commands:
```bash
go mod download
go mod tidy
```

#### 3. Generated Files Not Found
**Error:** `package grpc-hello-world/hello is not in GOROOT`

**Solution:** Make sure you've generated the protobuf files:
```bash
mkdir -p hello
protoc --go_out=./hello --go_opt=paths=source_relative \
    --go-grpc_out=./hello --go-grpc_opt=paths=source_relative \
    hello.proto
```

#### 4. grpcurl Connection Refused
**Error:** `Failed to dial target host "localhost:50051": connection refused`

**Solution:** Make sure the server is running first:
```bash
go run server.go
```

### Quick Fix Script

If you encounter any issues, run this complete setup:

```bash
#!/bin/bash
# Complete setup script

# Download dependencies
go mod download
go mod tidy

# Create hello directory
mkdir -p hello

# Generate protobuf code
protoc --go_out=./hello --go_opt=paths=source_relative \
    --go-grpc_out=./hello --go-grpc_opt=paths=source_relative \
    hello.proto

echo "Setup complete! Now run:"
echo "1. go run server.go"
echo "2. In another terminal: go run client.go"
```

## Project Structure

```
.
├── README.md           # This file
├── go.mod             # Go module definition
├── go.sum             # Dependency checksums
├── hello.proto        # Protocol Buffer definition
├── server.go          # gRPC server implementation
├── client.go          # gRPC client implementation
├── setup.sh           # Automated setup script
├── Makefile           # Build automation
└── hello/             # Generated protobuf code (create after running protoc)
    ├── hello.pb.go
    └── hello_grpc.pb.go
```

## Service Definition

The service defines two RPC methods:

- `SayHello`: Returns a simple greeting
- `SayHelloAgain`: Returns a "hello again" greeting

Both methods take a `HelloRequest` with a name field and return a `HelloReply` with a message field.

## Key Features

- **gRPC Reflection**: The server enables reflection, allowing grpcurl to work without requiring the proto file
- **Proper Module Structure**: Uses correct Go module imports to avoid relative import issues
- **Insecure Connection**: Uses plaintext connection for simplicity (use TLS in production)
- **Context Timeout**: Client includes proper timeout handling
- **Error Handling**: Proper error handling throughout the code

## Expected Output

### Server Output
```
2025/07/09 15:43:08 Server listening at [::]:50051
2025/07/09 15:43:15 Received: World
2025/07/09 15:43:15 Received again: World
```

### Client Output
```
2025/07/09 15:43:15 Greeting: Hello World
2025/07/09 15:43:15 Greeting again: Hello again World
```

### grpcurl Output
```json
{
  "message": "Hello World"
}
```

## Using the Makefile

The project includes a Makefile for common tasks:

```bash
# Setup and build everything
make all

# Generate protobuf code
make proto

# Run the server
make run-server

# Run the client
make run-client

# Run client with custom name
make run-client-name NAME=Alice

# Test with grpcurl
make test-grpcurl

# Clean generated files
make clean
```

## Development Notes

- The server runs on port 50051 by default
- gRPC reflection is enabled for easy testing with grpcurl
- Both client and server use insecure credentials for development
- The client accepts command-line arguments for custom names
- All import paths use the module name to avoid relative import issues

## Next Steps

- Add TLS/SSL for secure communication
- Implement streaming RPCs
- Add authentication and authorization
- Add proper logging and monitoring
- Write unit tests
- Add Docker support

## License

MIT License - feel free to use this code for learning and development purposes.