#!/usr/bin/env sh

case "$GSH_LAST_ACTION" in
  check_true|skip|goto|hardreset)
    rm -f "$GSH_TMP/ckpt_start_7"
    ;;
esac
