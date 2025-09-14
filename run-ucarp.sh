#!/usr/bin/env bash

# This variable will hold the PID of the background process
child_pid=0

# This function is called when the script receives a SIGTERM signal
function cleanup() {
  echo "Graceful shutdown requested..."

  echo "Removing set VIP"
  echo /app/vip-down.sh "$UCARP_HOST_DEVICE" "$UCARP_VIP_ADDRESS"
  /app/vip-down.sh "$UCARP_HOST_DEVICE" "$UCARP_VIP_ADDRESS"

  # If a child process is running, send it a SIGTERM
  if [ $child_pid -ne 0 ]; then
    echo "Sending SIGTERM to child process $child_pid"
    # Use 'kill -TERM' to send the signal
    kill -TERM "$child_pid"
    # Wait for the child process to terminate
    wait "$child_pid"
    echo "Child process terminated."
  fi

  echo "Shutdown complete."
  # Exit with a success code
  exit 0
}

# 'trap' sets up a command to be executed when a specific signal is received.
# Here, we are telling the script to call our 'cleanup' function on SIGTERM.
trap 'cleanup' SIGTERM

# --- Main Application Logic ---
echo "Starting main process..."

REQUIRED_PARAMS=("UCARP_VID" "UCARP_HOST_DEVICE" "UCARP_HOST_ADDRESS" "UCARP_VIP_ADDRESS" "UCARP_PASSWORD" "UCARP_PRIORITY")
MISSING_PARAMS=()

for param in "${REQUIRED_PARAMS[@]}"; do
  if [ -z "${!param}" ]; then
    MISSING_PARAMS+=("$param")
  fi
done

if [ ${#MISSING_PARAMS[@]} -gt 0 ]; then
  echo "You must provide the following environment variables: ${MISSING_PARAMS[*]}"
  exit 255
fi

echo /usr/sbin/ucarp --interface="$UCARP_HOST_DEVICE" --srcip="$UCARP_HOST_ADDRESS" --vhid="$UCARP_VID" --pass="$UCARP_PASSWORD" --addr="$UCARP_VIP_ADDRESS" --advskew="$UCARP_PRIORITY" --preempt --shutdown --neutral --upscript=/app/vip-up.sh --downscript=/app/vip-down.sh
/usr/sbin/ucarp --interface="$UCARP_HOST_DEVICE" \
  --srcip="$UCARP_HOST_ADDRESS" \
  --vhid="$UCARP_VID" \
  --pass="$UCARP_PASSWORD" \
  --addr="$UCARP_VIP_ADDRESS" \
  --advskew="$UCARP_PRIORITY" \
  --preempt --shutdown --neutral \
  --upscript=/app/vip-up.sh --downscript=/app/vip-down.sh &

# Capture the PID of the background process
child_pid=$!

# Wait for the child process to exit.
# This is crucial; otherwise, the script would finish, and the container would stop.
wait "$child_pid"
