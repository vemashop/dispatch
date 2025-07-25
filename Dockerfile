# Build stage
FROM golang:1.21 AS builder

WORKDIR /opt/server

# Copy your Go source code into the container
COPY main.go .

# Initialize Go module and build
RUN go mod init dispatch && \
    go get && \
    go build -o dispatch

# Final image
FROM alpine:latest

RUN adduser -S -D roboshop

WORKDIR /opt/server

# Copy the binary from builder
COPY --from=builder /opt/server/dispatch /opt/server/dispatch

USER roboshop
ENTRYPOINT ["/opt/server/dispatch"]
