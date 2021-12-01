FROM alpine:latest

RUN apk add --no-cache \
    nasm \
    libtool \
    gcc \
    gcc-cross-embedded \
    grub grub-bios grub-efi \
    xorriso \
    bash

VOLUME /root/env
WORKDIR /root/env

CMD ["/bin/bash"]
