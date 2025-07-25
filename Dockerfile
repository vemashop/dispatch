# Base image with Go for build stage
FROM golang:1.21 AS builder

# Set working directory
WORKDIR /app

# Download source code
ADD https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip /tmp/dispatch.zip

# Unzip and build
RUN apt-get update && apt-get install -y unzip && \
    unzip /tmp/dispatch.zip -d . && \
    go mod init dispatch && \
    go get && \
    go build -o dispatch

# Final lightweight image
FROM alpine:latest

RUN adduser -S -D roboshop
WORKDIR /app
COPY --from=builder /app/dispatch /app/dispatch

USER roboshop
ENTRYPOINT ["/app/dispatch"]
