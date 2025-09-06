#!/usr/bin/env bash

## Exit if not in Debian/Ubuntu
if ! command -v apt >/dev/null 2>&1; then
  exit 0;
fi

## Enable onefetch repository - https://onefetch.dev/
if ! command -v onefetch >/dev/null 2>&1; then
  sudo add-apt-repository ppa:o2sh/onefetch
  sudo apt-get update
fi
