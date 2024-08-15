FROM registry.access.redhat.com/ubi9/ubi:9.4-1181 as builder

RUN dnf install -y cmake gcc-c++ openssl-devel
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /tmp

COPY --chown=1001:1001 src /tmp/src
COPY --chown=1001:1001 Cargo* /tmp

RUN cargo build --release

FROM registry.access.redhat.com/ubi9/ubi-minimal:9.4-1194

COPY --from=builder /tmp/target/release/bridges /usr/local/bin/bridges

CMD ["/usr/local/bin/bridges"]
