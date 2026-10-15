#!/usr/bin/env sh

# keep the collection after a failed check (the player may already have
# saved it) and when quitting (so it is still there when the game resumes)
case "$GSH_LAST_ACTION" in
  check_false|exit)
    ;;
  *)
    module disable VESUVE >/dev/null 2>&1
    ;;
esac
