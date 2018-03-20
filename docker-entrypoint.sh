#!/usr/bin/env bash

CONFIGURATION_FILE="${LNDR_HOME}/lndr-backend/data/lndr-server.config"
VARIABLE_NAMES="AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY CREDIT_PROTOCOL_ADDRESS DB_HOST DB_NAME DB_PASSWORD DB_PORT DB_USER ETHEREUM_ACCOUNT ETHEREUM_CLIENT_URL ETHEREUM_GAS_PRICE ETHEREUM_MAX_GAS HEARTBEAT_INTERVAL ISSUE_CREDIT_EVENT LNDR_UCAC_JPY LNDR_UCAC_KRW LNDR_UCAC_USD S3_PHOTO_BUCKET SCAN_START_BLOCK URBAN_AIRSHIP_KEY URBAN_AIRSHIP_SECRET"

lndr_start() {
  cp "${CONFIGURATION_FILE}.j2" "${CONFIGURATION_FILE}"
  for VARIABLE_NAME in ${VARIABLE_NAMES}; do
    sed -i'' "s|{{${VARIABLE_NAME}}}|${!VARIABLE_NAME}|g" "${CONFIGURATION_FILE}"
  done
  lndr-server
}

lndr_delay() {
  local DELAY="$1"
  [ -n "${DELAY}" ] || DELAY="5"
  sleep "${DELAY}"
}

case "$1" in
  start)
    lndr_start
    ;;
  delay-start)
    lndr_delay && lndr_start
    ;;
  *)
    exec $*
    ;;
esac
