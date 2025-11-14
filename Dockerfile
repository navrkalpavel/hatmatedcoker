FROM alpine:3.20

# Upterm server binary
RUN apk add --no-cache curl openssh && \
    curl -L https://github.com/owenthereal/upterm/releases/latest/download/upterm-linux-amd64 \
      -o /usr/local/bin/upterm && \
    chmod +x /usr/local/bin/upterm

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
