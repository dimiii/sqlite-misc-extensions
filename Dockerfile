# Build Stage
FROM alpine:latest AS build

# Install dependencies
RUN \
    apk update && \
    apk upgrade && \
    apk add \
    alpine-sdk \
    build-base  \
    tcl-dev \
    tk-dev \
    mesa-dev \
    jpeg-dev \
    libjpeg-turbo-dev

# Download latest release
RUN \
    wget \
    -O sqlite.tar.gz \
    https://www.sqlite.org/src/tarball/sqlite.tar.gz?r=release && \
    tar xvfz sqlite.tar.gz

# Build sqlite
RUN \
    mkdir -p ./sqlite/build/ext/misc && \
    ./sqlite/configure --prefix=/usr && \
    make && \
    make install

# Build misc/ extensions
COPY build/Makefile.ext ./sqlite/build
RUN \
    cd ./sqlite/build && \
    make -f Makefile.ext build_misc

#  Main Stage
FROM alpine:latest

# Ship result
COPY --from=build ./sqlite/build/ext/misc /opt/sqlite-misc-extensions

# Reference output
CMD ["tree", "/opt/sqlite-misc-extensions"]
