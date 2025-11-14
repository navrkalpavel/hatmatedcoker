FROM tmate/tmate-ssh-server:2.3.0

USER root

# Extra tools for key generation
RUN apk add --no-cache curl bash openssh-keygen

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
