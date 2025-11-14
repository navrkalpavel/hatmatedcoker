FROM alpine:3.20

RUN apk add --no-cache curl openssh ca-certificates

ARG UPTERM_VERSION=0.17.0

# Arch detection
RUN ARCH=$(apk --print-arch) && \
    if [ "$ARCH" = "x86_64" ]; then \
        TARGET=amd64; \
    elif [ "$ARCH" = "aarch64" ]; then \
        TARGET=arm64; \
    else \
        echo "Unsupported architecture: $ARCH"; exit 1; \
    fi && \
    URL="https://github.com/owenthereal/upterm/releases/download/v${UPTERM_VERSION}/uptermd_linux_${TARGET}.tar.gz" && \
    echo "Downloading $URL" && \
    curl -L "$URL" -o /tmp/uptermd.tar.gz && \
    tar -xf /tmp/uptermd.tar.gz -C /usr/local/bin && \
    rm /tmp/uptermd.tar.gz && \
    chmod +x /usr/local/bin/uptermd

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
