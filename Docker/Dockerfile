FROM docker:dind

WORKDIR /app

RUN apk add --no-cache \
    bash \
    curl \
    python3 \
    python3-dev \
    py3-pip \
    build-base \
    libffi-dev \
    gfortran \
    openblas-dev \
    vim \
    tree \
    git

COPY requirements.txt .

ENV PATH="/app/venv/bin:$PATH"

RUN python3 -m venv /app/venv && \
    pip install --no-cache-dir -r requirements.txt

CMD ["bash"]
