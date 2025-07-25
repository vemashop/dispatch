# Base image with Go for build stage
FROM golang:1.21 AS builder

# Set working directory
WORKDIR /app

# Unzip and build
RUN go mod init dispatch && \
    go get && \
    go build -o dispatch

# Final lightweight image
FROM alpine:latest

RUN adduser -S -D roboshop
WORKDIR /app
COPY --from=builder /app/dispatch /app/dispatch

USER roboshop
ENTRYPOINT ["/app/dispatch"]
