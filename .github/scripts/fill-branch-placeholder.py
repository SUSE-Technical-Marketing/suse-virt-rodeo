#!/usr/bin/env python3
"""Fill track.yml's `__BRANCH__` placeholder for a CI run.

track.yml keeps `slug: suse-virt-rodeo-__BRANCH__` and
`title: SUSE Virtualization Rodeo __BRANCH__` in git. CI replaces the placeholder on
the runner's working tree only (never committed back):

- a branch name (already lowercased/slugified by the caller) replaces the placeholder
  as-is, so the separator in track.yml stays: `suse-virt-rodeo-my-branch`;
- no branch name (main, and the validate workflow) removes the placeholder together
  with its separator. Replacing it with an empty string instead leaves
  `slug: suse-virt-rodeo-`, which `instruqt track validate` rejects ("must be a valid
  slug (starts and ends with letter or digit ...)"), and a trailing space in the title.

Usage: fill-branch-placeholder.py [slugified-branch]
"""
import pathlib
import sys

repl = sys.argv[1] if len(sys.argv) > 1 else ""
path = pathlib.Path("track.yml")
text = path.read_text()
if repl:
    text = text.replace("__BRANCH__", repl)
else:
    text = text.replace("-__BRANCH__", "").replace(" __BRANCH__", "").replace("__BRANCH__", "")
path.write_text(text)
