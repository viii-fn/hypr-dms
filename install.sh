#!/usr/bin/env bash

SRC_DIR="$HOME/hypr-dms"      # the folder holding the things you want to link
DEST_DIR="$HOME/.config"      # the folder the symlinks should go in
SELF="$(basename "$0")"       # this script's own file name ("link.sh")

mkdir -p "$DEST_DIR"          # make sure the destination exists

for item in "$SRC_DIR"/*; do          # loop over every item in SRC_DIR
  name="$(basename "$item")"          # strip the path, keep just the name

  if [ "$name" = "$SELF" ]; then      # is this item the script itself?
    echo "skipping $name"             # yes: do nothing with it
  else
    ln -sfn "$item" "$DEST_DIR/$name" # no: create the symlink
    echo "linked $name"
  fi
done
