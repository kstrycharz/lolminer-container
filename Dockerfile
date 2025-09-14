# Use NVIDIA OpenCL runtime so lolMiner can see GPUs via --gpus all
FROM nvidia/cuda:12.6.2-runtime-ubuntu24.04

ARG DEBIAN_FRONTEND=noninteractive
# Your preview/beta release details
ARG LOLMINER_VERSION=1.98_pb
ARG LOLMINER_BASENAME=lolMiner_v1.98_public_beta_Lin64
ARG LOLMINER_TARBALL=${LOLMINER_BASENAME}.tar.gz
ARG LOLMINER_URL=https://github.com/Lolliedieb/lolMiner-preview/releases/download/${LOLMINER_VERSION}/${LOLMINER_TARBALL}

# Tools + OpenCL ICD
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates wget tzdata pciutils ocl-icd-libopencl1 clinfo \
 && rm -rf /var/lib/apt/lists/*

# Everything lives in /workspace
WORKDIR /workspace

# Download & extract; auto-detect the folder containing lolMiner binary (handles "1.98pb/")
RUN set -eux; \
    mkdir -p /workspace; \
    wget -O /tmp/lolminer.tar.gz "${LOLMINER_URL}"; \
    tar -xzf /tmp/lolminer.tar.gz -C /workspace; \
    rm -f /tmp/lolminer.tar.gz; \
    LM_PATH="$(find /workspace -type f -name lolMiner -perm -u+x | head -n1)"; \
    test -n "$LM_PATH"; \
    LM_DIR="$(dirname "$LM_PATH")"; \
    rm -rf /workspace/lolminer; \
    mv "$LM_DIR" /workspace/lolminer; \
    chmod +x /workspace/lolminer/lolMiner

# Entrypoint (no user switching, root is fine)
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Make the miner folder primary and add to PATH
WORKDIR /workspace/lolminer
ENV PATH="/workspace/lolminer:${PATH}"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["--version"]