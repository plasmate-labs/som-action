FROM rust:slim

RUN apt-get update && apt-get install -y python3 && rm -rf /var/lib/apt/lists/*
RUN cargo install plasmate

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
