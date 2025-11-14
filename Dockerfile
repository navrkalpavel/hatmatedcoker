FROM alpine:3.20

RUN apk add --no-cache curl openssh

# Detect architecture and download correct Upterm binary
RUN ARCH=$(apk --print-arch) && \
    if [ "$ARCH" = "x86_64" ]; then \
        URL="https://github.com/owenthereal/upterm/releases/latest/download/upterm-linux-amd64"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        URL="https://github.com/owenthereal/upterm/releases/latest/download/upterm-linux-arm64"; \
    else \
        echo "Unsupported architecture: $ARCH"; exit 1; \
    fi; \
    echo "Downloading Upterm: $URL"; \
    curl -L "$URL" -o /usr/local/bin/upterm; \
    chmod +x /usr/local/bin/upterm

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
