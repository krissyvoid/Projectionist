#!/bin/sh
printf '\033c\033]0;%s\a' Projectionist
base_path="$(dirname "$(realpath "$0")")"
"$base_path/The Projectionist.x86_64" "$@"
