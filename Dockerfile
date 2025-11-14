FROM alpine:3.20

# Potřebujeme curl, ssh (kvůli klíčům) a dpkg-deb na rozbalení .deb balíčku
RUN apk add --no-cache curl openssh ca-certificates dpkg

# Verzi si můžeš případně přepsat build argumentem
ARG UPTERM_VERSION=0.17.0
ENV UPTERM_VERSION=${UPTERM_VERSION}

# Detekce architektury a stažení správného .deb z GitHubu
RUN ARCH=$(apk --print-arch) && \
    if [ "$ARCH" = "x86_64" ]; then \
        TARGET=amd64; \
    elif [ "$ARCH" = "aarch64" ]; then \
        TARGET=arm64; \
    else \
        echo "Unsupported architecture: $ARCH"; exit 1; \
    fi; \
    URL="https://github.com/owenthereal/upterm/releases/download/v${UPTERM_VERSION}/upterm_linux_${TARGET}.deb"; \
    echo "Downloading Upterm from $URL"; \
    curl -L "$URL" -o /tmp/upterm.deb && \
    dpkg-deb -x /tmp/upterm.deb / && \
    rm /tmp/upterm.deb

# V .deb balíčku by měl být /usr/bin/upterm, takže ho máme rovnou v PATH
# pro jistotu můžeš přidat symlink, ale typicky není potřeba:
# RUN ln -s /usr/bin/upterm /usr/local/bin/upterm || true

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
