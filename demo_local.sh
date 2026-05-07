#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-6001}"
MESSAGE="${2:-Xin chao FIT4012 - Sender Receiver demo}"

mkdir -p logs

PYTHONUNBUFFERED=1 \
RECEIVER_HOST=127.0.0.1 \
RECEIVER_PORT="$PORT" \
SOCKET_TIMEOUT=10 \
RECEIVER_LOG_FILE=logs/01-happy-path-receiver.txt \
python receiver.py &
receiver_pid=$!

sleep 1

SERVER_IP=127.0.0.1 \
SERVER_PORT="$PORT" \
MESSAGE="$MESSAGE" \
SENDER_LOG_FILE=logs/01-happy-path-sender.txt \
python sender.py

wait "$receiver_pid"
