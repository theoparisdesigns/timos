FROM rust:alpine as builder

WORKDIR /app
COPY . .
RUN make all

FROM alpine:latest

RUN apk add --no-cache qemu-img qemu-system-x86_64 qemu-system-aarch64
WORKDIR /app
COPY --from=builder /app/target ./target
RUN qemu-system-x86_64 ./target

