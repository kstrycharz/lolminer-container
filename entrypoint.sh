#!/usr/bin/env bash
set -euo pipefail

# If a custom tarball is provided at runtime, download and switch to it
if [[ -n "${LOLMINER_DL_URL:-}" ]]; then
  echo "[entrypoint] Downloading lolMiner from ${LOLMINER_DL_URL}..."
  tmp=/opt/lm_tmp
  rm -rf "$tmp"; mkdir -p "$tmp"
  wget -O "$tmp/lolminer.tar.gz" "${LOLMINER_DL_URL}"
  tar -xzf "$tmp/lolminer.tar.gz" -C "$tmp"
  NEWDIR="$(find "$tmp" -type f -name lolMiner -perm -u+x -printf '%h\n' | head -n1)"
  if [[ -z "${NEWDIR:-}" ]]; then
    echo "[entrypoint] Could not find lolMiner binary in downloaded archive." >&2
    exit 1
  fi
  rm -rf /opt/lolminer
  mv "$NEWDIR" /opt/lolminer
  chmod +x /opt/lolminer/lolMiner
  rm -rf "$tmp"
fi

# Auto-build command if POOL & WALLET provided
if [[ -n "${POOL:-}" && -n "${WALLET:-}" ]]; then
  : "${ALGO:=SHA3x}"
  exec ./lolMiner -a "$ALGO" --pool "$POOL" --user "${WALLET}" 
else
  echo "No Config"

fi
  

