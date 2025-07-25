# Build stage
FROM golang:1.21 AS builder

WORKDIR /app

# Copy your Go source code into the container
COPY main.go .

# Initialize Go module and build
RUN go mod init dispatch && \
    go get && \
    go build -o dispatch

# Final image
FROM alpine:latest

RUN adduser -S -D roboshop
WORKDIR /app

# Copy the binary from builder
COPY --from=builder /app/dispatch /app/dispatch

USER roboshop
ENTRYPOINT ["/app/dispatch"]
