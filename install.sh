#!/usr/bin/env bash
# https://taxjson.com/install.sh — runs the installer from the taxjson repository.
set -euo pipefail
SRC="https://raw.githubusercontent.com/taxjson/taxjson/main/install.sh"
SCRIPT="$(curl -fsSL "$SRC")" || { echo "Could not download the installer from $SRC — check your connection and try again." >&2; exit 1; }
[ -n "$SCRIPT" ] || { echo "Downloaded an empty installer from $SRC — try again in a minute." >&2; exit 1; }
exec bash -c "$SCRIPT"
