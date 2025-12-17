FROM ubuntu:22.04

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    python3 \
    vim \
    tree \
    git && \
    rm -rf /var/lib/apt/lists/*

CMD ["bash"]
