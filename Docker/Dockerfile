FROM ubuntu:latest

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    python3 \
    tree \
    git && \
    rm -rf /var/lib/apt/lists/*

CMD ["bash"]
