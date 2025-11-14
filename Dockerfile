# 1) Build fáze – vezmeme zdrojáky tmate-ssh-server (ty už v repu mít nemusíš,
#    my používáme to, co je v tomhle Dockerfile – v HA add-on repu máš jen tento soubor)
FROM alpine:3.16 AS build

# runtime knihovny + build toolchain
RUN apk add --no-cache msgpack-c ncurses-libs libevent libexecinfo openssl zlib && \
    apk add --no-cache \
      autoconf \
      automake \
      cmake \
      g++ \
      gcc \
      git \
      libevent-dev \
      libexecinfo-dev \
      linux-headers \
      make \
      msgpack-c-dev \
      ncurses-dev \
      openssl-dev \
      zlib-dev \
      libssh-dev

# stáhnout zdrojáky tmate-ssh-server z GitHubu
RUN mkdir -p /src && \
    cd /src && \
    git clone https://github.com/tmate-io/tmate-ssh-server.git && \
    cd tmate-ssh-server && \
    ./autogen.sh && \
    ./configure --prefix=/usr CFLAGS="-D_GNU_SOURCE" && \
    make -j"$(nproc)" && \
    make install

# 2) Minimální runtime image
FROM alpine:3.16

# runtime závislosti + nástroje, které používáš v run.sh/create_keys.sh
RUN apk add --no-cache \
      bash \
      gdb \
      libevent \
      libexecinfo \
      libssh \
      msgpack-c \
      ncurses-libs \
      openssl \
      zlib \
      curl \
      openssh-keygen

# z build fáze přeneseme binárku serveru
COPY --from=build /usr/bin/tmate-ssh-server /usr/bin/

# tvůj startovací skript
COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
