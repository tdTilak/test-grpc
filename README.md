# gRPC Hello World

A simple gRPC Hello World implementation in Go with client, server, and grpcurl examples.

## Features

- Protocol Buffer service definition
- gRPC server implementation with reflection enabled
- gRPC client implementation
- grpcurl command examples for testing
- Complete setup and build instructions

## Prerequisites

- Go 1.21 or later
- Protocol Buffer compiler (protoc)
- gRPC Go plugins
- grpcurl (for testing)

## Quick Setup

### 1. Install Dependencies

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

### 2. Generate Go Code from Proto

```bash
# Create hello directory and generate code
mkdir hello
protoc --go_out=./hello --go_opt=paths=source_relative \
    --go-grpc_out=./hello --go-grpc_opt=paths=source_relative \
    hello.proto
```

### 3. Install Go Dependencies

```bash
go mod tidy
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

## Project Structure

```
.
├── README.md           # This file
├── go.mod             # Go module definition
├── hello.proto        # Protocol Buffer definition
├── server.go          # gRPC server implementation
├── client.go          # gRPC client implementation
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

## Development Notes

- The server runs on port 50051 by default
- gRPC reflection is enabled for easy testing with grpcurl
- Both client and server use insecure credentials for development
- The client accepts command-line arguments for custom names

## Next Steps

- Add TLS/SSL for secure communication
- Implement streaming RPCs
- Add authentication and authorization
- Add proper logging and monitoring
- Write unit tests

## License

MIT License - feel free to use this code for learning and development purposes.