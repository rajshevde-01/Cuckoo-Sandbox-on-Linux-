FROM python:3.10-slim

# Install system dependencies
# Cuckoo 3 requires slightly different deps than 2.0
RUN apt-get update && apt-get install -y \
    git curl wget \
    tcpdump libcap2-bin \
    ssdeep libfuzzy-dev \
    gcc g++ make \
    libjpeg-dev zlib1g-dev \
    postgresql-client \
    swig libssl-dev dpkg-dev \
    libmagic1 libyara-dev \
    && rm -rf /var/lib/apt/lists/*

# Create cuckoo user
RUN adduser --disabled-password --gecos "" cuckoo

# Configure tcpdump permissions
RUN setcap cap_net_raw,cap_net_admin=eip /usr/bin/tcpdump

# Switch to cuckoo user
USER cuckoo
WORKDIR /home/cuckoo

# Install Cuckoo 3 (Beta)
# Standard pip install cuckoo is Python 2 only.
# We install from the open source Cuckoo 3 repository.
# Cuckoo 3 structure requires older setuptools or explicit config.
# Cuckoo 3 is a monorepo. We must install sub-packages individually.
RUN pip install --user -U pip setuptools wheel

# Install dependencies from quickstart
RUN pip install --user -U git+https://github.com/cert-ee/peepdf \
    git+https://github.com/cert-ee/sflock \
    git+https://github.com/cert-ee/roach \
    git+https://github.com/cert-ee/httpreplay \
    daphne

# Clone and install Cuckoo 3 sub-packages
RUN git clone https://github.com/cert-ee/cuckoo3.git /tmp/cuckoo3 && \
    cd /tmp/cuckoo3 && \
    pip install --user ./common ./processing ./machineries ./web ./node ./core

# Add local bin to PATH
ENV PATH="/home/cuckoo/.local/bin:${PATH}"

# Expose default ports
EXPOSE 8000 2042

# Cuckoo 3 uses 'cuckoo' command but init might differ
CMD ["cuckoo", "--debug"]
