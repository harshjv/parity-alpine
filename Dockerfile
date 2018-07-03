FROM alpine:edge

ENV PARITY_VERSION 1.10.8

WORKDIR /build

RUN apk add --no-cache gcc musl-dev pkgconfig g++ make curl \
						eudev-dev rust cargo git file binutils \
						libusb-dev linux-headers perl

ENV RUST_BACKTRACE 1

RUN rustc -vV && \
    cargo -V && \
    gcc -v && \
    g++ -v

RUN wget https://github.com/paritytech/parity/archive/v${PARITY_VERSION}.tar.gz && \
    tar -xzf v${PARITY_VERSION}.tar.gz && \
    rm v${PARITY_VERSION}.tar.gz

RUN cd parity-${PARITY_VERSION} && \
  	cargo build --release --verbose && \
  	ls /build/parity-${PARITY_VERSION}/target/release/parity && \
  	strip /build/parity-${PARITY_VERSION}/target/release/parity

RUN cp /build/parity-${PARITY_VERSION}/target/release/parity /build && \
    rm -rf /build/parity-${PARITY_VERSION}

RUN file /build/parity

EXPOSE 8080 8545 8180

ENTRYPOINT ["/build/parity"]

CMD ["--chain=dev"]
