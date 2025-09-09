#!/usrbin/env bash

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

echo ucarp --interface="$UCARP_HOST_DEVICE" --srcip="$UCARP_HOST_ADDRESS" --vhid="$UCARP_VID" --pass="$UCARP_PASSWORD" --addr="$UCARP_VIP_ADDRESS" --advskew="$UCARP_PRIORITY" --preempt --shutdown --neutral --upscript=/etc/ucarp/vip-up.sh --downscript=/etc/ucarp/vip-down.sh
ucarp --interface="$UCARP_HOST_DEVICE" \
  --srcip="$UCARP_HOST_ADDRESS" \
  --vhid="$UCARP_VID" \
  --pass="$UCARP_PASSWORD" \
  --addr="$UCARP_VIP_ADDRESS" \
  --advskew="$UCARP_PRIORITY" \
  --preempt --shutdown --neutral \
  --upscript=/etc/ucarp/vip-up.sh --downscript=/etc/ucarp/vip-down.sh
