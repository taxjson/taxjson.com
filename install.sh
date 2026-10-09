#!/usr/bin/env bash
# https://taxjson.com/install.sh — runs the taxjson installer.
#   bash -c "$(curl -fsSL https://taxjson.com/install.sh)"
#   bash -c "$(curl -fsSL https://taxjson.com/install.sh)" _ --without-fetch
#   bash -c "$(curl -fsSL https://taxjson.com/install.sh)" _ --channel beta
# Arguments (--channel ..., --without-fetch, and the older --with-fetch)
# and the TAXJSON_* environment knobs pass through. The installer
# installs the taxjson-fetch plugin by default; --without-fetch leaves it
# out (an installer from before that default installs the core only, so
# the flag is dropped for it).
#
# The installer comes from the release `stable` names (channels.json on
# taxjson's main branch), not from main: a change to install.sh reaches
# new users when the release carrying it is promoted. Only the dev
# channel (--channel dev, TAXJSON_CHANNEL=dev, or an install that
# remembered dev) runs main's installer.
set -euo pipefail
# Everything runs from main(), called on the last line: a download cut off
# part-way defines nothing that runs.
main() {
  RAW="https://raw.githubusercontent.com/taxjson/taxjson"
  die() { echo "$*" >&2; exit 1; }
  get() { curl -fsSL "$1" || die "Could not download $1 — check your connection and try again."; }

  # The channel asked for, only to know whether it is dev (the installer
  # itself resolves everything else): --channel, TAXJSON_CHANNEL, then the
  # channel this machine remembered.
  ASKED=""
  prev=""
  for a in "$@"; do
    [ "$prev" = --channel ] && ASKED="$a"
    case "$a" in --channel=*) ASKED="${a#--channel=}" ;; esac
    prev="$a"
  done
  ASKED="${ASKED:-${TAXJSON_CHANNEL:-}}"
  CH="$ASKED"
  if [ -z "$CH" ] && [ -f "$HOME/.config/taxjson/channel" ]; then
    CH="$(tr -d '[:space:]' < "$HOME/.config/taxjson/channel" || true)"
  fi

  if [ "$CH" = dev ]; then
    REF=main
    SRC="$RAW/refs/heads/main/install.sh"
  else
    CHANNELS="$(get "$RAW/refs/heads/main/channels.json")"
    REF="$(printf '%s\n' "$CHANNELS" | sed -nE 's/.*"stable"[[:space:]]*:[[:space:]]*"(v[0-9]+\.[0-9]+\.[0-9]+)".*/\1/p' | sed -n 1p)"
    [ -n "$REF" ] || die "taxjson's channels.json names no stable release — try again later, or use --channel dev."
    # By tag explicitly: a branch with the same name can never shadow it.
    SRC="$RAW/refs/tags/$REF/install.sh"
  fi
  SCRIPT="$(get "$SRC")"
  [ -n "$SCRIPT" ] || die "Downloaded an empty installer from $SRC — try again in a minute."
  # An installer from before channels (it knows no --channel) installs the
  # newest release and refuses a channel argument.
  if [ "$REF" != main ] && [ -n "$ASKED" ] && ! printf '%s' "$SCRIPT" | grep -q -- '--channel'; then
    die "The stable release ($REF) has an installer from before release channels.
  Re-run without --channel / TAXJSON_CHANNEL (it installs the newest release), or use --channel dev."
  fi
  # An installer from before fetch-by-default knows no --without-fetch;
  # it installs the core only, which is what the flag asks for.
  if ! printf '%s' "$SCRIPT" | grep -q -- '--without-fetch'; then
    ARGS=()
    for a in "$@"; do [ "$a" = --without-fetch ] || ARGS+=("$a"); done
    set -- ${ARGS[@]+"${ARGS[@]}"}
  fi
  exec bash -c "$SCRIPT" install.sh "$@"
}
main "$@"
